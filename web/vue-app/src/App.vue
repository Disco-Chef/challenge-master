<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
    <indexation-form @add:input="addInput" />
    <form-inputs-table v-bind:inputs="inputs" />
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
          start: "21/01/2010",
          signed: "25/02/2018",
          region: "brussels",
          rent: 500,
        },
      ],
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
    }
  }
}
</script>

<style>
  body {
    margin: 0 auto;
    width: 500px;
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
