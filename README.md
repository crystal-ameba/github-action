# Crystal Ameba GitHub Action

GitHub Action that lints Crystal code with [Ameba](https://github.com/crystal-ameba/ameba)
linter.

![](https://github.com/crystal-ameba/github-action/raw/master/assets/sample.png)

## Inputs

> [!WARNING]
> Available only for versions 1.0.0+ and the `master` branch.

| Input name     | Description                                  | Required? | Default value  |
|----------------|----------------------------------------------|-----------|----------------|
| `config`       | Path to the configuration file               | ✗         | —              |
| `version`      | Version of Ameba ruleset to check against    | ✗         | —              |
| `min-severity` | Minimum severity of issues to report         | ✗         | `convention`   |
| `only`         | Run only given rules (or groups)             | ✗         | —              |
| `except`       | Disable the given rules (or groups)          | ✗         | —              |

## Usage

To use Crystal Ameba Linter, add the following step to your GitHub action workflow:

```diff
+      - name: Run Ameba Linter
+        uses: crystal-ameba/github-action@v1
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
        uses: actions/checkout@v7

      - name: Run Ameba Linter
        uses: crystal-ameba/github-action@v1
```

## Compatibility Versions

| Ameba version | GitHub Action version |
|--------------|------------------------|
| latest       | 1.0.0                  |
| ~> 1.6.4     | 0.12.0                 |
| ~> 1.6.3     | 0.11.0                 |
| ~> 1.6.2     | 0.10.0                 |
| ~> 1.6.1     | 0.9.0                  |
| ~> 1.5.0     | 0.8.0                  |
| ~> 1.4.0     | 0.7.1                  |
| 1.3.1        | 0.6.0                  |
| 1.2.0        | 0.5.1                  |
| 1.1.0        | 0.4.0                  |
| 1.0.1        | 0.3.1                  |
| 1.0.0        | 0.3.0                  |
| 0.14.3       | 0.2.12                 |

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
