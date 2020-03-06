<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->

    <form-inputs-table v-if="dataReceived" v-bind:inputs="inputs" />
    <indexation-form   v-else @add:input="sendInputs" />
  </div>
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import IndexationForm from './components/IndexationForm.vue'
import FormInputsTable from './components/FormInputsTable.vue'

export default {
  name: 'App',
  components: {
    // HelloWorld
    IndexationForm,
    FormInputsTable
  },
  data() {
    return {
      inputs: [
        {
          id: 1,
          start: "01/09/2010",
          signed: "25/07/2010",
          region: "brussels",
          rent: 500,
          base_index: 1112.74,
          current_index: 131.72,
          new_rent: 584.18
        },
      ],
      dataReceived: false
    }
  },
  methods: {
    addInput(input) {
      const lastId =
        this.inputs.length > 0
          ? this.inputs[this.inputs.length - 1].id
          : 0;
      const id = lastId + 1;
      const newInput = { ...input, id };

      this.inputs = [...this.inputs, newInput];
  },
  async sendInputs(input) {
    try {
      const response = await fetch('http://localhost:4567/v1/indexations', {
        method: 'POST',
        body: JSON.stringify(input),
        headers: {
          'Content-type': 'application/json; charset=UTF-8' },
      })
      const data = await response.json()
      // at this point, data is the response from sinatra
      let newLine = {
          rent: input.rent,
          new_rent: data.new_rent,
          base_index: data.base_index,
          current_index: data.current_index
      }
      this.addInput(newLine)

      this.inputs = [newLine]
      this.dataReceived = true
      } catch (error) {
        console.error(error)
      }
    }
  }
  // mounted() {
  //   this.getInputs()
  // }
}
</script>

<style>
  body {
    margin: 0 auto;
    width: 700px;
  }
  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }

  button {
    background: #009435;
    border: 1px solid #009435;
  }
</style>
