# dataset-tagger

App to fetch metadata from a dataset and complete the annotations in a basic web form.
The metadata model in this branch is derived from https://github.com/opengeospatial/ogcapi-records/blob/master/core/openapi/schemas/recordGeoJSON.yaml

This file is converted to json an used almost as is in src/model.json (geometry simplified to string for simplicity)

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
