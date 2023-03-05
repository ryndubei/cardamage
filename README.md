# cardamage

Hack the Burgh 2023 entry - Car Damage Analyser

Requirements
------------

- Linux or MacOS
- python3

#### Python
- Pillow
- tkinter

Build
-----

Create `.secrets/API_KEY.secret` in `cardamage` containing your RapidAPI API key.

Install `stack` via ghcup:

```
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Then run

```
git clone https://github.com/ryndubei/cardamage.git
cd cardamage
stack build
cp -r "$(stack path --local-install-root)"/* ./program
```

to build the program.

Run
---
```
cd cardamage
python3 program/main.py
```
