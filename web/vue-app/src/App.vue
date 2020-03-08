<template>
  <div id="app">
    <div id="more-rent" class="results-gif" v-if="dataReceived && goodResult"></div>
    <div id="less-rent" class="results-gif" v-if="dataReceived && (goodResult === false)"></div>
    <results-component v-if="dataReceived" v-bind:inputs="inputs" />
    <indexation-form   v-else @add:input="sendInputs" />
  </div>
</template>

<script>
import IndexationForm from './components/IndexationForm.vue'
import ResultsComponent from './components/ResultsComponent.vue'

export default {
  name: 'App',
  components: {
    IndexationForm,
    ResultsComponent
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
      dataReceived: false,
      goodResult: false
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
      this.goodResult = newLine.rent < newLine.new_rent

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
  .results-gif {
    width: 700px;
    height: 400px;
    background-position: center;
    border-radius: 5px;
    background-size: cover;
  }
  #more-rent {
    background-image: url(https://media.giphy.com/media/26BGP98lm74FJgfNS/giphy.gif);
  }
  #less-rent {
    background-image: url(https://media.giphy.com/media/71PLYtZUiPRg4/giphy.gif);
  }
</style>
