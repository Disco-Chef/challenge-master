<template>
  <div id="indexation-form">
    <form @submit.prevent="handleSubmit">
      <div class="groups">
        <div class="group">
          <label>Contract Start Date:</label>
          <input
            ref="first"
            type="text"
            v-model="input.start"
          />
        </div>
        <div class="group">
          <label>Contract Signed On:</label>
          <input
            type="text"
            v-model="input.signed"
          />
        </div>
      </div>
      <div class="groups">
        <div class="group">
          <label>Rent (Euro):</label>
          <input
            type="text"
            v-model="input.rent"
          />
        </div>
        <div class="group">
          <label>Region (brussels, flanders, wallonia):</label>
          <input
            type="text"
            v-model="input.region"
          />
        </div>
      </div>

      <!-- Big fail trying with radio buttons -->
      <!--  <label for="region">Brussels</label>
      <input type="radio" id="brussels" value="brussels" v-model="region">
      <label for="region">Flanders</label>
      <input type="radio" id="flanders" value="flanders" v-model="region">
      <label for="region">Wallonia</label>
      <input type="radio" id="wallonia" value="wallonia" v-model="region">
      <br>
      <span>Region: {{ region }}</span> -->
      <button>Compute indexed rent!</button>

    </form>
  </div>
</template>

<script>
  export default {
    name: 'indexation-form',
    data() {
      return {
        submitting: false,
        error: false,
        success: false,
        input: {
          start: '',
          signed: '',
          rent: '',
          region: ''
        },
      }
    },
  }
</script>

<style scoped>
  form {
    margin-bottom: 2rem;
  }

  .groups {
    display: flex;
    justify-content: space-between;
  }
  input {
    width: 150px;
  }
  label {
    width: 150px;
  }
</style>
