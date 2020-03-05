<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
    <indexation-form />
  </div>
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import IndexationForm from './components/IndexationForm.vue'


export default {
  name: 'App',
  components: {
    // HelloWorld
    IndexationForm
  }
}
</script>

<style>
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
