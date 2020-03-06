<!-- Once api calls and calculations are done, add new indexed rent for user to see past -->
<template>
  <div id="form-inputs-table">
    <div v-for="input in inputs" :key="input.id" id="results-container">
      <h1>Rent Indexation Result</h1>
      <h4>Your indexed rent amounts to:</h4>
      <h3>{{ input.new_rent }} Eur</h3>
      <div class="flexing-between">
        <div class="larger-titles">Base rent </div>
        <div class="values">({{ input.rent }})</div>
        <div class="larger-titles"> X </div>
        <div class="larger-titles">Current index</div>
        <div class="values">({{ input.current_index }})</div>
      </div>
      <div class="flexing-around">
        <div class="larger-titles">Base Index</div>
        <div class="values">({{ input.base_index }})</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'form-inputs-table',
    props: {
      inputs: Array,
    },
  }
</script>

<style scoped>
  #results-container {
  }
  .flexing-between {
    display: flex;
    flex-direction: row;
    border-bottom: 1px solid;
    justify-content: space-between;
    align-items: center;
  }
  .flexing-around {
    display: flex;
  justify-content: center;
  align-items: center;
  }
  .larger-titles {
    font-size: 2rem;
  }
  .values {
    font-size: 1.8rem;
    margin: 0px 8px;
  }
</style>
