# ameba-github_action

GitHub Action for Ameba.

## Usage

Add the following to your GitHub action workflow to use Crystal Ameba Linter:

``` yaml
- name: Crystal Ameba Linter
  uses: crystal-ameba/ameba-action@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Development

Build the docker image:

```sh
docker build . -t ameba/github-action
```

Run it:

```sh
docker run -it ameba/github-action
```

## Contributing

1. Fork it (<https://github.com/your-github-user/ameba-github_action/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Vitalii Elenhaupt](https://github.com/your-github-user) - creator and maintainer
