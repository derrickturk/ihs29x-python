# ihs29x

A simple spec-driven streaming ("SAX-style") parser for IHS 297 and 298 files, based on the specifications provided by [twoninetyex](https://github.com/derrickturk/twoninetyex).
It handles 297 and 298 files in either fixed or comma delimited format.
In accordance with my reading of the spec, it even handles intermixed formats within a single file, based on (sub-)file headers.

The only interesting function is `ihs29x.stream_records`, which may be called on an open file-like object in text mode.

Live documentation is available at https://derrickturk.github.io/ihs29x-python/docs/ihs29x.html.

Available under the MIT license.

---

## Usage
For example, try:
```python
import sys

from ihs29x import stream_records


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(f'Usage {argv[0]} <298-or-297-file>', file=sys.stderr)
        return 2

    with open(argv[1]) as f:
        for r in stream_records(f):
            print(r)

    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
```

---

### (c) 2023 terminus, LLC
