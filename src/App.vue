<template>
  <v-app>
   <v-main>
    <v-container>
      <v-tabs 
      v-model="toptab"
      background-color="transparent"
      color="basil"
      grow
      centered>
        <v-tabs-slider></v-tabs-slider>
        <v-tab href="#tab-1">Welcome</v-tab>
        <v-tab href="#tab-2">Annotate</v-tab>
        <v-tab href="#tab-3">Complete</v-tab>
      </v-tabs>
    
    <v-tabs-items v-model="toptab">
      <v-tab-item value="tab-1">
        <v-card flat>
          <v-card-text>

            <intro-page ref="IntroPage" @submitDoi="fetchDOI" />

          </v-card-text>
        </v-card>
      </v-tab-item>
      <v-tab-item value="tab-2">
        <v-card flat>
          <v-card-text>
          
              <h1>Annotate</h1>
              <v-form v-model="valid">
                <v-jsf v-model="model" :schema="schema" />
                <v-btn
                  color="success"
                  class="mr-4"
                  @click="saveData"
                >  submit
                </v-btn>
              </v-form>

          </v-card-text>
        </v-card>
      </v-tab-item>
      <v-tab-item value="tab-3">
        <v-card flat>
          <v-card-text>
              <h1>Thank you!</h1>
              <p>
              Your data has been submitted. You can export the metadata in various formats:
              </p>
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs-items>

      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import VJsf from '@koumoul/vjsf/lib/VJsf.js'
import '@koumoul/vjsf/lib/VJsf.css'
import '@koumoul/vjsf/lib/deps/third-party.js'
import IntroPage from './components/IntroPage.vue'

const opts =  {
    
}

export default {
  name: 'App',
  components: { 
    'IntroPage': IntroPage,
    'VJsf': VJsf 
  },
  opts,
  data: () => ({
    valid: false,
    model: {},
    opts,
    toptab: null,
    schema: {
      type: 'object',
      properties: {
        id: { type: 'string', description: "A UUID, URI, URN or DOI to identify the dataset" },
        title: { type: 'string', required: true, description: "A consize distinctive title for the dataset" },
        abstract: { type: 'string', description: "A brief description of the dataset" },
        keywords: { type: 'string', description: "Separate keywords by semicolon ';'" },
        language: { type: 'string', description: "Main language in dataset" },
        status: { type: 'string', description: "Select the current status of the dataset", "enum": [
                  "completed","historicalArchive","obsolete","onGoing","planned","required","underDevelopment"] },
        maintenancefrequency: { type: 'string', description: 'Frequency with which the dataset is updated' },
        "modDate": {
            "type": "string",
            "title": "Modification date",
            "format": "date",
            "description": "Last modification date for the dataset"
        },
        usageconstraints: {
          "type": "string",
          "title": "Usage constraints",
          "x-fromUrl": "./codelists/datalicenses.json",
          "description": "Indicates the legal constraints which may apply for usage of the data",
          "x-itemsProp": "results",
          "x-itemTitle": "title",
          "x-itemKey": "id"
        },
        accessconstraints: {
          "type": "string",
          "title": "Access constraints",
          "description": "Indicates any acces constrains, if relevant",
          "x-fromUrl": "./codelists/accessconstraints.json",
          "x-itemsProp": "results",
          "x-itemTitle": "title",
          "x-itemKey": "id"
        },
        topic: {
          "type": "string",
          "title": "Topic category",
          "description": "A categorisation based on ISO19139",
          "x-fromUrl": "./codelists/topicCat.json",
          "x-itemsProp": "results",
          "x-itemTitle": "title",
          "x-itemKey": "id"
        },
        geographicalextent: { 
          type: 'string',
          "description": "Geographical extent, e.g. 'Verdon, France' or geographic bounds, e.g. '4,50 6,52'", },
        temporalextent: { "type": "array",
              "title": "Reference period",
              "items": [
                {
                  "type": "string",
                  "format": "date",
                  "title": "Start"
                },
                {
                  "type": "string",
                  "format": "date",
                  "title": "End"
                }
              ]
        },
        scale: { type: 'number', 'description': 'Scale (vector) or resolution (grid)' },
        crs: { type: 'string', 'description': 'Spatial projection system, e.g. EPSG:4326' },
        url: { type: 'string', 'description': 'Location of the Dataset file or API endpoint', 'title': 'File location' },
        format: { type: 'string', 'description': 'File format dataset' },
        contacts: {
          "type": "array",
          "title": "Contacts",
          "description": "Add a contact",
          "x-itemTitle": "organizaton",
          "items": {
            "type": "object",
            "required": [
              "organizaton", "email", "role"
            ],
            "properties": {
              "name": {
                "type": "string",
                "title": "Name"
              },
              "organizaton": {
                "type": "string",
                "title": "Organizaton"
              },
              "email": {
                "type": "string",
                "title": "Email"
              },
              "role": {
                "type": "string",
                "enum": [
                  "author", "custodian", "distributor", "originator", "owner", "pointOfContact", "principalInvestigator", "processor", "publisher", "resourceProvider", "user", "metadata-contact"
                ],
                "title": "Select a role"
              }
            }
          }
        },
        citations: {
          "type": "array",
          "title": "Citations",
          "description": "Articles which reference this dataset",
          "x-itemTitle": "title",
          "items": {
            "type": "object",
            "properties": {
              "doi": {
                "type": "string",
                "title": "DOI"
              },
              "title": {
                "type": "string",
                "title": "title"
              },
              "authors": {
                "type": "string",
                "title": "Authors"
              },
              "journal": {
                "type": "string",
                "title": "Journal"
              },
              "date": {
                "type": "string",
                "format":"date",
                "title": "Publication date"
              }
            }
          }
        }
      }
    }
  }),
  methods: {
    saveData() {
      console.log(this);
    },
    fetchDOI(doi) {
        console.log(doi)
        if (doi.indexOf('') == -1) {
          alert('provide valid doi');
        } else {
          this.axios.get(this.doi, {headers: {'Accept': 'application/json'}}).then(function(response){
            this.id = doi;
            if (response.title) { this.title = response.title } 
            if (response.subject) { this.keywords = response.subject.join('; ') }
          })
        }
    }
  }
};
</script>

