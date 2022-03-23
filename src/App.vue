<template>
  <v-app>
   <v-main>
    <v-container>
      <v-tabs 
      v-model="toptab"
      background-color="transparent"
      color="basil"
      grow>
        <v-tabs-slider></v-tabs-slider>
        <v-tab href="#tab-1">Welcome</v-tab>
        <v-tab href="#tab-2">Annotate</v-tab>
      </v-tabs>
    
    <v-tabs-items v-model="toptab">
      <v-tab-item value="tab-1">
        <v-card flat>
          <v-card-text>

            <intro-page ref="IntroPage" @submitDoi="fetchDOI" @setLayer="setWMS" @updateModel="setModel" />

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

//import model
const mdl = require('./model.json');
//import template
const tpl = require('./template.json');

const opts = {}

export default {
  name: 'App',
  components: { 
    'IntroPage': IntroPage,
    'VJsf': VJsf 
  },
  opts,
  data: () => ({
    valid: false,
    model: tpl,
    opts,
    toptab: null,
    schema: mdl
  }),
  methods: {
    saveData() {
      const data = JSON.stringify(this.model)
      const blob = new Blob([data], {type: 'text/plain'})
      const e = document.createEvent('MouseEvents'),
      a = document.createElement('a');
      a.download = "test.json";
      a.href = window.URL.createObjectURL(blob);
      a.dataset.downloadurl = ['text/json', a.download, a.href].join(':');
      e.initEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
      a.dispatchEvent(e);
    },
    setModel (mdl) {
      Object.keys(mdl).forEach(k => this.model[k] = mdl[k]);
    },
    setWMS(selectedLYRS,layers,caps){

      let self = this;
      let layerName = "";
      
      selectedLYRS.forEach(function(l){
        let myLayer = layers.find(ls => ls.name === l);
        if (myLayer){
          self.model.title = myLayer.title;
          try {
            console.log(myLayer);
            self.model.abstract = myLayer.abstract;
            layerName = myLayer.name;
            self.model.keywords = myLayer.keywordlist.Keyword.join(', ');
          } catch (e) { console.log(e)}
          try {
           let bb = myLayer.ex_geographicboundingbox;
           self.model.geographicalextent = bb.westBoundLongitude.toString() + ',' + +bb.southBoundLatitude +  ',' + bb.eastBoundLongitude + ',' + bb.northBoundLatitude;
          } catch (e) { console.log(e)}
        }   
      })
      this.model.id = caps.href.split('?')[0] + '#' + layerName;
      this.model.distributions = [{href:caps.href,name:layerName,protocol:'OGC:WMS'}];
      try {
        let c = caps.contact;
        this.model.contacts=[{email:c.ContactElectronicMailAddress[0],
              role:'publisher',
              name: c.ContactPersonPrimary[0].ContactPerson[0],
              organisation:  c.ContactPersonPrimary[0].ContactOrganization[0]
          }];
      } catch (e) { console.log(e)}
      try {
        let l = caps.license;
        console.log(l);
        this.model.accessconstraints=l;
      } catch (e) { console.log(e)}
    },
    fetchDOI(doi) {
        if (doi.trim().indexOf('http') == 0) { 
          //normal case
          doi = doi.trim();
        } else if (doi.indexOf('doi:') == 0) {
          doi = doi.replace('doi:','https://doi.org/');
        } else {
          doi = 'https://doi.org/' + doi;
        }
        if (doi.trim() != '') {
          let self = this;
          this.axios.get(doi, {headers: {'Accept': 'application/x-bibtex'}}).then(function(response){
            let doiMD = {}; 
            response.data.split(',').forEach(function(f){
              let tpl = f.split('=');
              if (tpl.length==2){
                doiMD[tpl[0].trim()]=tpl[1].replace('{','').replace('}','').trim()
              }
            })

            self.model.id = doi;
            //publisher and authors
            try {
              let cnt = [];
              (doiMD.author).split(' and ').forEach(function(c){
                cnt.push({"name":c, role:'author'});
              })
              if (doiMD.publisher){
                cnt.push({"organisation":doiMD.publisher,role:'publisher'});
              }
              self.model.contacts = cnt;
            } catch (e) { console.log(e) }
            if (doiMD.title) { self.model.title = doiMD.title } 
            if (doiMD.language) { self.model.language = doiMD.language } 
            try {
              if (doiMD.year) { 
                  self.model.date = doiMD.year.toString() + "-" + (doiMD.month?(["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"].findIndex(m => (m === doiMD.month))+1):1).toString() + "-1" } 
            } catch (e) { console.log(e) }
            if (doiMD.keywords) { self.model.keywords = doiMD.keywords}
            self.model.id = doi.split('doi.org/')[1];
            alert('Doi '+ doi +' imported!')
            self.model.toptab = 'tab-2';
          }).catch(function(){alert('Failed to retrieve DOI: ' + doi)}) 
        }
    }
  }
};
</script>

