<template>
  <v-container>
    <v-row class="text-center">
      <v-col cols="12">
       
              <h1>Welcome</h1>
              <p>
              This wizard guides you through the registration of a new dataset.
              In the first step you are invited to add references to existing resources related to the dataset.
              The wizard will try to parse this information in order to fetch existing metadata.
              In the next step you will be invited to complete any resource information.
              In the final step you can save and/or export the results in various formats.
              </p>

              <h2>Existing resources</h2>

             <v-form ref="form">
                <p>
                If a DOI is registerd for this dataset, Bibtex metadata will be extracted for this DOI
                </p>
                <v-text-field @blur="$emit('submitDoi', doi)"
                  v-model="doi"
                  label="DOI"
                  description=""
                ></v-text-field>

                <p>If this dataset is registered in a catalog, add a link to the record (as iso19139)</p>

                <v-text-field
                  v-model="record"
                  label="Metadata record"
                ></v-text-field>

                <p>The dataset is exposed as a OGC Webservice?</p>

                <v-text-field
                  v-model="service"
                  label="Web Map Service" @blur="fetchCapabilities"
                ></v-text-field>

                <v-select
                          v-model="layers"
                          :items="WmsLayers"
                          :menu-props="{ maxHeight: '400' }"
                          label="Select"
                          item-text="title"
                          item-value="name"
                          multiple
                          hint="Pick your layer(s)"
                          persistent-hint
                        ></v-select>

                <p>Upload a sample of the dataset</p>

                <v-text-field 
                  v-model="dataset"
                  label="Datafile"
                ></v-text-field>

              </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>

  var parseString = require('xml2js').parseString;

  export default {
    emits: ['submitDoi'],
    setup(props, ctx) {
      ctx.emit('submitDoi')
    },
    name: 'IntroPage',
    data: () => ({
     'doi': "",
     'service': "",
     'WmsLayers': [],
     'layers': [],
     'upload': "",
     'record': "",
     'dataset': "",
    }),
    methods : {
      fetchCapabilities(){
        let self = this;
        this.axios.get(this.service.split('?')[0] + '?request=GetCapabilities&service=WMS&version=1.3.0')
          .then(response => {
            parseString(response.data, (err, result) => {
              if(err) {
                console.log(err)
              } else {
                //populate layers
                console.log(result);
                try {
                result['WMS_Capabilities']['Capability'][0]['Layer'][0]['Layer'].forEach(function(l){
                  console.log(l)
                  if(l.Name && l.Name[0]) {
                    self.WmsLayers.push({name:l.Name[0],title:l.Title[0],abstract:l.Abstract[0]});
                  }
                })
                } catch (e) {
                  console.log(result);
                  console.log(e);
                }
              }
            });        
          })
      }
    }
  }
</script>
