# CodeMeta to Zenodo Converter

GitHub Action to convert `codemeta.json` files to `.zenodo.json` format using the [eOSSR](https://gitlab.com/escape-ossr/eossr) library.

This action uses the `eossr-codemeta2zenodo` command to convert metadata descriptive files from the CodeMeta schema to the Zenodo schema, making it easy to automatically generate Zenodo-compatible metadata for your software releases.

## Features

- 🚀 Automatically converts CodeMeta metadata to Zenodo format
- 🔧 Configurable input file path (defaults to `codemeta.json`)
- 🛡️ Safe by default: fails if output file exists unless explicitly overwritten
- ✅ Validates `.zenodo.json` with `eossr-zenodo-validator`
- 🎯 Optional `--add-escape2020` support to add ESCAPE2020 community/grant metadata
- 📦 Uses the official eossr container

## Usage

### Basic Usage

Add this step to your workflow to convert `codemeta.json` in your repository root to `.zenodo.json`:

```yaml
- name: Convert CodeMeta to Zenodo
  uses: escape2020/codemeta2zenodo@v1.1.0
```

### Custom Input File

The default behaviour will look for a `codemeta.json` file at the ROOT of your repository (note that this is the CodeMeta recommendation) but you can specify a custom path to your CodeMeta file :

```yaml
- name: Convert CodeMeta to Zenodo
  uses: escape2020/codemeta2zenodo@v1.1.0
  with:
    codemeta_file: 'metadata/codemeta.json'
```

### With Overwrite

Allow overwriting an existing `.zenodo.json` file:

```yaml
- name: Convert CodeMeta to Zenodo
  uses: escape2020/codemeta2zenodo@v1.1.0
  with:
    overwrite: true
```

### Add ESCAPE2020 Community and Grant

Option to add the ESCAPE community and grant in the metadata:

```yaml
- name: Convert CodeMeta to Zenodo
  uses: escape2020/codemeta2zenodo@v1.1.0
  with:
    add_escape2020: true
```


## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `codemeta_file` | Path to the `codemeta.json` file | No | `codemeta.json` |
| `overwrite` | Overwrite existing `.zenodo.json` file if it exists | No | `false` |
| `add_escape2020` | Add ESCAPE2020 community and grant number to `.zenodo.json` | No | `false` |

## Outputs

| Output | Description |
|--------|-------------|
| `zenodo_file` | Path to the generated .zenodo.json file (always `./.zenodo.json`) |

## Complete Workflow Examples

### Convert and Commit

Automatically convert CodeMeta to Zenodo and commit the result:

```yaml
name: Update Zenodo Metadata

on:
  push:
    paths:
      - 'codemeta.json'
  workflow_dispatch:

jobs:
  convert:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Convert CodeMeta to Zenodo
        uses: escape2020/codemeta2zenodo@v1.1.0
        with:
          overwrite: true

      - name: Commit changes
        run: |
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add .zenodo.json
          git diff --quiet && git diff --staged --quiet || git commit -m "Update .zenodo.json from codemeta.json"
          git push
```

### Convert on Release

Generate Zenodo metadata when creating a release:

```yaml
name: Prepare Release

on:
  release:
    types: [published]

jobs:
  prepare-zenodo:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Convert CodeMeta to Zenodo
        uses: escape2020/codemeta2zenodo@v1.1.0
        with:
          overwrite: true

      - name: Upload .zenodo.json as release asset
        uses: actions/upload-release-asset@v1.1.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ github.event.release.upload_url }}
          asset_path: ./.zenodo.json
          asset_name: .zenodo.json
          asset_content_type: application/json
```

## About

This action uses the [eossr](https://gitlab.com/escape-ossr/eossr) (ESCAPE Open Source Software Repository) container which provides tools for managing scientific software metadata.

eossr v2.2.0 enables the `--add-escape2020` option to map CodeMeta funding information to Zenodo grant metadata.

### What is CodeMeta?

[CodeMeta](https://codemeta.github.io/) is a metadata standard for software that helps describe software projects in a structured way, making them more discoverable and citable.

### What is Zenodo?

[Zenodo](https://zenodo.org/) is a general-purpose open-access repository that allows researchers to deposit research papers, datasets, research software, reports, and any other research related digital artifacts. The `.zenodo.json` file allows you to configure how your software releases are archived on Zenodo.

## Citation

If you use this action in your research, please cite the ESCAPE Open-source Software and Service Repository:

```bibtex
@Article{Vuillaume2023,
  author  = {Vuillaume, T and Al-Turany, M and Füßling, M and Gal, T and Garcia, E and Graf, K and Hughes, G and Kettenis, M and Kresan, D and Schnabel, J and Tacke, C and Verkouter, M},
  title   = {The ESCAPE Open-source Software and Service Repository},
  journal = {Open Research Europe},
  year    = {2023},
  volume  = {3},
  number  = {46},
  doi     = {10.12688/openreseurope.15692.2},
  note    = {version 2; peer review: 5 approved}
}
```

See [CITATION.cff](CITATION.cff) for the full citation information.

## License

This action is provided as-is. The eossr library is part of the [ESCAPE project](https://projectescape.eu/).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

