# dataset-tagger

App to fetch metadata from a dataset and complete the annotations in a basic web form.
The metadata model is oriented on pygeometa's mcf (a yaml encoding related to iso19139)
Model is defined on model.json (idea could be to override this file during deployment), some special fields added for vizualisations (defined by [vjsf](https://koumoul-dev.github.io/vuetify-jsonschema-form/latest/examples#basic)). Codelists are generally loaded from codelists/*

Capabilities: 
- import metadata from:
  - DOI
  - WMS
  - iso19139 upload/reference (use python api to parse iso19139)
  - upload dataset (use python api to extract metadata from data; projection, bounds, name, format, column names, data-type)
- edit metadata, the editor is generated from json-schema, change the editor by updating the schema file  
- export metadata as mcf
- persist metadata via python api (on git/pycsw/...), hope to support OGC API Records transactions soon

## installation

requires 
- NODE 
- YARN

```
yarn install
yarn serve
```

visit http://localhost:8080

Import a record, or move to 'annotate' tab directly to start editing
