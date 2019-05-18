Limit to specific distribution

```
env:
  matrix:
    - INSTANCE: platform-instance01
    - INSTANCE: platform-instance02
script:
  - molecule converge -- --limit="localhost,${INSTANCE}"
```