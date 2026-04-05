import json

with open(r"D:\programiranje\powershell\data.json", "r", encoding="utf-8") as f:
    data = json.load(f)
    for d in data:
        key = d['key']
        cmd = d['command']
        # print(f"{cmd} -> {key}")
        if " " in key:
            chords = key.split(" ")
            for c in chords:
                combos = c.split("+")
        else:
            print(key)
            combo = c.split("+")
            # if len(combo)==2
                # if len(combo[1])== 1:
                    # print(f"{cmd} -> {key}")
                    # print(combo)
