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
                
                <v-text-field
                  v-model="doi"
                  label="DOI"
                  description="If a DOI is registerd for this dataset, DataCite metadata will be extracted for this DOI"
                ></v-text-field>

                <!--<v-text-field
                  v-model="record"
                  label="Metadata record"
                ></v-text-field>

                <v-text-field
                  v-model="dataset"
                  label="Datafile"
                ></v-text-field>

                <v-file-input
                  v-model="upload"
                  label="Upload a metadata or data file"
                ></v-file-input>-->

                <v-btn
                  color="success"
                  class="mr-4"
                  @click="$emit('submitDOI', doi)"
                >
                  submit
                </v-btn>

              </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  export default {
    name: 'IntroPage',
    data: () => ({
     'doi': "http://dx.doi.org/10.1038/nrd842",
     'upload': "",
     'record': "",
     'dataset': "",
    })
  }
</script>
