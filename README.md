# Crystal Ameba GitHub Action

GitHub Action that lints Crystal code with [Ameba](https://github.com/crystal-ameba/ameba)
linter.

![](https://github.com/crystal-ameba/github-action/raw/master/assets/sample.png)

## Usage

To use Crystal Ameba Linter, add the following step to your GitHub action workflow:

```diff
+      - name: Run Ameba Linter
+        uses: crystal-ameba/github-action@master
```

### Example Workflow

```yaml
name: Ameba

on:
  push:
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
      - name: Download source
        uses: actions/checkout@v6

      - name: Run Ameba Linter
        uses: crystal-ameba/github-action@master
```

## Compatibility Versions

| Ameba version | GitHub Action version |
|---------------|-----------------------|
| master        | master                |
| ~> v1.6.4     | v0.12.0               |
| ~> v1.6.3     | v0.11.0               |
| ~> v1.6.2     | v0.10.0               |
| ~> v1.6.1     | v0.9.0                |
| ~> v1.5.0     | v0.8.0                |
| ~> v1.4.0     | v0.7.1                |
| v1.3.1        | v0.6.0                |
| v1.2.0        | v0.5.1                |
| v1.1.0        | v0.4.0                |
| v1.0.1        | v0.3.1                |
| v1.0.0        | v0.3.0                |
| v0.14.3       | v0.2.12               |

### Bump versions

* Crystal version should be updated in `Dockerfile` file (version of the image).

## Contributing

1. Fork it (<https://github.com/crystal-ameba/github-action/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Vitalii Elenhaupt](https://github.com/veelenga) - creator and maintainer
- [Sijawusz Pur Rahnama](https://github.com/Sija) - contributor and maintainer
