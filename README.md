# ihs29x

A simple spec-driven streaming ("SAX-style") parser for IHS 297 and 298 files, based on the specifications provided by [twoninetyex](https://github.com/derrickturk/twoninetyex).
It handles 297 and 298 files in either fixed or comma delimited format.
In accordance with my reading of the spec, it even handles intermixed formats within a single file, based on (sub-)file headers.

The only interesting function is `ihs29x.stream_records`, which may be called on an open file-like object in text mode.

---

### (c) 2023 terminus, LLC
