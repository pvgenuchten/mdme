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
          
              <h1>Dataset annotation</h1>
              <p>A subset of fields to annotate a dataset with required metadata elements</p>
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
    model: {
      id:'',
      title:'',
      keywords:'',
      date:'',
      contacts:[{name:'',role:''}],
      distributions:[{url:''}],
      citations:[{doi:'',author:'',title:''}],
      language:'', 
      description:''
    },
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
        distributions: {
          "type": "array",
          "title": "Distributions",
          "description": "Add a distribution",
          "x-itemTitle": "distribution",
          "items": {
            "type": "object",
            "required": [
              "href"
            ],
            "properties": {
              "name": {
                "type": "string",
                "description": "Name of the resource",
                "title": "Name"
              },
              "href": {
                "type": "string",
                "description": "Url of the dataset or service",
                "title": "Distribution link"
              },
              "protocol": {
                "type": "string",
                "description": "Format of protocol of the service",
                "title": "Format/Protocol"
              }
            }
          }
        },
        contacts: {
          "type": "array",
          "title": "Contacts",
          "description": "Add a contact",
          "x-itemTitle": "organizaton",
          "items": {
            "type": "object",
            "required": [
              "role"
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
        if (doi.indexOf('http://dx.doi.org') == -1) {
          alert('provide valid doi');
        } else {
          let self = this;
          this.axios.get(doi, {headers: {'Accept': 'application/json'}}).then(function(response){
            self.model.id = doi;
            try {
              self.model.contacts = [{"name":response.data.author[0].family, role:'author'}];
            } catch (e) { console.log(e) }
            if (response.data.title) { self.model.title = response.data.title } 
            if (response.data.language) { self.model.language = response.data.language } 
            if (response.data.description) { self.model.abstract = response.data.description } 
            if (response.data.reference){
              try {
                let cits=[];
                response.data.reference.forEach(function(cit){
                  if (cit['DOI']){
                    cits.push({doi:cit['DOI'],title:cit['unstructured'],authors:cit['author']})
                  }
                })
                self.model.citations = cits;
              } catch (e) { console.log(e) }
            }
            if (response.data.link){
              try {
                let lnks=[];
                response.data.link.forEach(function(lnk){
                  if (lnk['rel'] && lnk['rel']=='item'){
                    lnks.push({href:lnk['URL'],protocol:lnk['content-type']})
                  }
                })
                self.model.distributions = lnks;
              } catch (e) { console.log(e) }
            }
            try {
              if (response.data.created) { 
                  self.model.date = response.data.created['date-time'].split('T')[0] } 
            } catch (e) { console.log(e) }
            if (response.data.subject) { self.model.keywords = response.data.subject.join('; ')}
            alert('Doi '+ doi +' imported!')
            self.model.toptab = 'tab-2';
          }).catch(function(){alert('Failed to retrieve DOI: ' + doi)}) 
        }
    }
  }
};
</script>

