<!-- Once api calls and calculations are done, add new indexed rent for user to see past -->
<template>
  <div id="form-inputs-table">
    <h1>Your previous inputs</h1>
    <table>
      <thead>
        <tr>
          <th>Start</th>
          <th>Signed</th>
          <th>Region</th>
          <th>Current Rent</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="input in inputs" :key="input.id">
          <td>{{ input.start }}</td>
          <td>{{ input.signed }}</td>
          <td>{{ input.region }}</td>
          <td>{{ input.rent }}</td>
        </tr>
      </tbody>
    </table>
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
  th {
    text-align: center;
  }
  td {
    text-align: center;
  }
</style>
