#!/usr/bin/env python3
"""Generate Karabiner-Elements rules that mirror kanata/kanata.kbd on macOS.

Rewrites complex_modifications in ~/.config/karabiner/karabiner.json (selected
profile); everything else in the file is preserved.

Ported:
  - Caps Lock: tap = Esc, hold = Caps Lock.
  - \\| = backspace (fwd delete in the nav layer).
  - Space: tap = space, hold = nav layer (hjkl arrows, q = `, [ = \\,
    bspc and \\ = fwd delete, f = plain shift). Same prior-idle / tap-repress as the
    HRMs; a key pressed within ARM ms of Space is a roll (space, then the key).
  - Homerow mods, GACS order, "timeless" style:
      prior idle   HRM pressed < PRIOR_IDLE ms after any key = plain letter
      tap repress  tap then re-press < TAP_REPRESS ms = plain letter (repeat)
      opposite     other-hand key resolves the HRM as hold once it has been
                   held >= ARM ms; earlier = roll, letters in order
      same hand    same-hand key resolves the HRM as tap until HOLD_TIMEOUT
      stacking     same-hand HRM pressed < CHORD ms or >= ARM ms after another
                   pending one stacks modifiers and marks the hand as chorded;
                   any key then resolves every pending HRM as hold at once
                   (CHORD..ARM ms apart = roll, letters in order)
      unknown hand keys outside both hands (space, ret, digits...) = hold
  - kanata's Cmd->Ctrl GUI layer is not ported: macOS is the behavior it emulates.

Mechanism: an idle HRM press holds its modifier lazily (sent only together with
another key). Rolls are undone by later manipulators that match the lazy
modifier as `mandatory`, which Karabiner lifts from their output.
"""
import json
import pathlib
import sys

PRIOR_IDLE = 150    # kanata tap-hold-require-prior-idle
TAP_REPRESS = 175   # kanata $tt
HOLD_TIMEOUT = 280  # kanata $ht
ARM = 150           # stands in for the -release (balanced) decision
CHORD = 50          # same-hand HRMs pressed this close together = mod chord

LEFT = "q w e r t a s d f g z x c v b".split()
RIGHT = "y u i o p h j k l semicolon n m comma period slash".split()
OTHER = (
    "1 2 3 4 5 6 7 8 9 0 grave_accent_and_tilde hyphen equal_sign "
    "open_bracket close_bracket backslash quote return_or_enter tab spacebar "
    "delete_or_backspace escape left_arrow right_arrow up_arrow down_arrow"
).split()

HRM = {
    "a": "left_control", "s": "left_option", "d": "left_command", "f": "left_shift",
    "j": "right_shift", "k": "right_command", "l": "right_option", "semicolon": "right_control",
}

NAV = {
    "h": "left_arrow", "j": "down_arrow", "k": "up_arrow", "l": "right_arrow",
    "q": "grave_accent_and_tilde", "open_bracket": "backslash",
    "delete_or_backspace": "delete_forward", "backslash": "delete_forward",
    "f": "left_shift",
}

REMAP = {"backslash": "delete_or_backspace"}

NOW = "system.now.milliseconds"


def hand(key):
    return "L" if key in LEFT else "R" if key in RIGHT else None


def out(key):
    return {"key_code": REMAP.get(key, key)}


def chord(h):
    return f"hrm_chord_{h}"


def var(name, value=None, expression=None):
    body = {"name": name}
    if expression is not None:
        body["expression"] = expression
    else:
        body["value"] = value
    return {"set_variable": body}


def expr(e):
    return {"type": "expression_if", "expression": e}


def frm(key, mandatory=None):
    mods = {"optional": ["any"]}
    if mandatory:
        mods["mandatory"] = [mandatory]
    return {"key_code": key, "modifiers": mods}


def manip(key, to, conditions=(), mandatory=None, **extra):
    m = {"type": "basic", "from": frm(key, mandatory), "to": to}
    if conditions:
        m["conditions"] = list(conditions)
    m.update(extra)
    return m


def v(key):
    return f"hrm_{key}"


TOUCH = var("hrm_last", expression=NOW)


def caps_rule():
    return {"description": "Caps Lock: tap = Esc, hold = Caps Lock (kanata port)", "manipulators": [{
        "type": "basic",
        "from": frm("caps_lock"),
        "to": [TOUCH],
        "to_if_alone": [{"key_code": "escape"}],
        "to_if_held_down": [{"key_code": "caps_lock"}],
        "parameters": {
            "basic.to_if_alone_timeout_milliseconds": HOLD_TIMEOUT,
            "basic.to_if_held_down_threshold_milliseconds": HOLD_TIMEOUT,
        },
    }]}


def nav_rule():
    """nav: 0 = off, 1 = Space held, 2 = Space already emitted by a roll.

    Space only arms the layer when no HRM is active; otherwise it falls through
    to the HRM rule as a plain space, so mod+space keeps working.
    """
    hrms_idle = " and ".join(f"{v(y)} == 0" for y in HRM)
    ms = [{
        "type": "basic",
        "from": frm("spacebar"),
        "conditions": [expr(f"{hrms_idle} and {NOW} - hrm_last >= {PRIOR_IDLE}"
                            f" and nav_rep <= {NOW}")],
        "to": [var("nav", 1), var("nav_down", expression=NOW), TOUCH],
        "to_if_alone": [var("nav_rep", expression=f"{NOW} + {TAP_REPRESS}"),
                        {"key_code": "spacebar"}],
        "to_after_key_up": [var("nav", 0)],
        "parameters": {"basic.to_if_alone_timeout_milliseconds": HOLD_TIMEOUT},
    }]
    rolling = expr(f"nav == 1 and {NOW} - nav_down < {ARM}")
    for key in LEFT + RIGHT + OTHER:
        if key != "spacebar":
            ms.append(manip(key, [var("nav", 2), TOUCH, {"key_code": "spacebar"},
                                  out(key)], [rolling]))
    for src, dst in NAV.items():
        ms.append(manip(src, [TOUCH, {"key_code": dst}],
                        [{"type": "variable_if", "name": "nav", "value": 1}]))
    return {"description": "Space hold: nav layer (kanata port)", "manipulators": ms}


def resolve_and_lift(key):
    """Manipulators that settle pending/tapped HRMs when `key` is pressed."""
    ms = []
    kh = hand(key)
    for y, mod in HRM.items():
        if y == key:
            continue
        if kh is not None:
            elapsed = f"{NOW} - {v(y)}_down"
            if key in HRM and hand(y) == kh:
                window = f"{elapsed} >= {CHORD} and {elapsed} < {ARM}"
            else:
                window = f"{elapsed} < {HOLD_TIMEOUT if hand(y) == kh else ARM}"
            ms.append(manip(
                key,
                [var(v(y), 3), TOUCH, {"key_code": y}, out(key)],
                [expr(f"{v(y)} == 1 and {chord(hand(y))} == 0 and {window}")],
                mandatory=mod,
            ))
        ms.append(manip(key, [TOUCH, out(key)],
                        [expr(f"{v(y)} == 3")], mandatory=mod))
    return ms


def hrm_manipulators(key, mod):
    ms = resolve_and_lift(key)
    plain = [TOUCH, {"key_code": key}]
    opposite = [y for y in HRM if hand(y) != hand(key)]
    ms.append(manip(key, plain, [expr(" or ".join(
        f"{v(y)} == 1 or {v(y)} == 2" for y in opposite))]))
    same = [y for y in HRM if y != key and hand(y) == hand(key)]
    stack = " or ".join(f"{v(y)} == 2 or ({v(y)} == 1 and ({NOW} - {v(y)}_down < {CHORD}"
                        f" or {NOW} - {v(y)}_down >= {ARM}))" for y in same)
    ms.append(hold(key, mod, [expr(stack)], [var(chord(hand(key)), 1)]))
    ms.append(manip(key, plain, [expr(f"{NOW} - hrm_last < {PRIOR_IDLE}")]))
    ms.append(manip(key, plain, [expr(f"{v(key)}_rep > {NOW}")]))
    ms.append(hold(key, mod))
    return ms


def hold(key, mod, conditions=(), extra=()):
    m = {
        "type": "basic",
        "from": frm(key),
        "to": [var(v(key), 1), var(f"{v(key)}_down", expression=NOW), TOUCH, *extra,
               {"key_code": mod, "lazy": True}],
        "to_if_alone": [var(f"{v(key)}_rep", expression=f"{NOW} + {TAP_REPRESS}"),
                        {"key_code": key}],
        "to_if_held_down": [var(v(key), 2), {"key_code": mod}],
        "to_after_key_up": [var(v(key), 0), var(chord(hand(key)), 0)],
        "parameters": {
            "basic.to_if_alone_timeout_milliseconds": HOLD_TIMEOUT,
            "basic.to_if_held_down_threshold_milliseconds": HOLD_TIMEOUT,
        },
    }
    if conditions:
        m["conditions"] = list(conditions)
    return m


def hrm_rule():
    ms = []
    for key, mod in HRM.items():
        ms += hrm_manipulators(key, mod)
    for key in LEFT + RIGHT + OTHER:
        if key in HRM:
            continue
        ms += resolve_and_lift(key)
        ms.append(manip(key, [TOUCH, out(key)]))
    return {"description": "Homerow mods GACS, timeless-style (kanata port)", "manipulators": ms}


def main():
    path = pathlib.Path(sys.argv[1] if len(sys.argv) > 1
                        else "~/.config/karabiner/karabiner.json").expanduser()
    config = json.loads(path.read_text())
    profile = next(p for p in config["profiles"] if p.get("selected"))
    profile["complex_modifications"] = {"rules": [caps_rule(), nav_rule(), hrm_rule()]}
    path.write_text(json.dumps(config, indent=2) + "\n")


if __name__ == "__main__":
    main()
