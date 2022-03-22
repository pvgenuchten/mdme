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
                          @change="$emit('setLayer', layers, WmsLayers, WMSCaps)"
                        ></v-select>

                <p>Upload a iso19139 metadata document</p>

                <file-reader @load="parseMetadata($event)"></file-reader>



                <p>Upload a sample of the dataset</p>

                <file-reader @load="data = $event"></file-reader>
                <textarea rows="10" v-model="data"></textarea>
                
              </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import FileReader from "./FileReader";
var parseString = require('xml2js').parseString;

export default {
  emits: ['submitDoi', 'setLayer', 'updateModel' ],
  setup(props, ctx) {
    ctx.emit('submitDoi')
  },
  name: 'IntroPage',
  data: () => ({
    'doi': "",
    'metadata': "",
    'data': "",
    'service': "",
    'WMSCaps': [],
    'WmsLayers': [],
    'layers': [],
    'upload': "",
    'record': "",
    'WMSContact':{}
  }),
  components : {
    FileReader
  },
  methods : {
    parseMetadata (str) {
      console.log(str);
      parseString(str, (err, result) => {
        if(err) {
          console.log(err)
        } else {
          try {
            let model = {id: result['gmd:MD_Metadata']['gmd:fileIdentifier'][0]['gco:CharacterString'][0]};
            this.$emit('updateModel',model);
          } catch (e) {console.log(e)}
        }
      });
    },
    fetchCapabilities(){
      let self = this;
      this.axios.get(this.service.split('?')[0] + '?request=GetCapabilities&service=WMS&version=1.3.0')
        .then(response => {
          parseString(response.data, (err, result) => {
            if(err) {
              console.log(err)
            } else {
              this.WMSCaps = {
                href: this.service,
                contact: result['WMS_Capabilities'].Service[0].ContactInformation[0],
                license: result['WMS_Capabilities'].Service[0].AccessConstraints[0]
              }
              try {
              result['WMS_Capabilities']['Capability'][0]['Layer'][0]['Layer'].forEach(function(lyr){
                  let myLayer = {}
                  Object.keys(lyr).forEach(function(k){
                    if (lyr[k][0]) myLayer[k.toLowerCase()] = lyr[k][0];
                  })
                  if (myLayer.name){
                    self.WmsLayers.push(myLayer);
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
