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
            :class="{ 'has-error': submitting && invalidStart }"
            @focus="clearStatus"
            @keypress="clearStatus"
          />
        </div>
        <div class="group">
          <label>Contract Signed On:</label>
          <input
            type="text"
            v-model="input.signed"
            :class="{ 'has-error': submitting && invalidSigned }"
            @focus="clearStatus"
          />
        </div>
      </div>
      <div class="groups">
        <div class="group">
          <label>Rent (Euro):</label>
          <input
            type="text"
            v-model="input.rent"
            :class="{ 'has-error': submitting && invalidRent }"
            @focus="clearStatus"
          />
        </div>
        <div class="group">
          <label>Region (brussels, flanders, wallonia):</label>
          <input
            type="text"
            v-model="input.region"
            :class="{ 'has-error': submitting && invalidRegion }"
            @focus="clearStatus"
          />
        </div>
      </div>


      <br>
      <p v-if="error && submitting" class="error-message">
        ❗Please fill out all required fields
      </p>
      <p v-if="success" class="success-message">
        ✅ Indexed rent successfully added
      </p>
      <br>
      <!-- Big fail radio buttons -->
      <!-- <label for="region">Brussels</label>
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
          region: '',
        },
      }
    },
    methods: {
      handleSubmit() {
        // console.log("testing handleSubmit")
        this.submitting = true
        this.clearStatus()

        if (this.invalidRent || this.invalidRegion || this.invalidStart || this.invalidSigned) {
          this.error = true
          return
        }

        this.$emit('add:input', this.input)
        this.$refs.first.focus()
        this.input = {
          start: '',
          signed: '',
          rent: '',
          region: ''
        }
        this.error = false
        this.success = true
        this.submitting = false

      },

      clearStatus() {
        this.success = false
        this.error = false
      }
    },
    computed: {
      // Add more validation later (rent must be positive number, start and signed cant be in the future, region must be one of the tree options)
      invalidStart() {
        return this.input.start === ''
      },
      invalidSigned() {
        return this.input.signed === ''
      },
      invalidRent() {
        return this.input.rent === ''
      },
      invalidRegion() {
        return this.input.region === ''
      },
    },
  }
</script>

<style scoped>
  form {
    margin-bottom: 2rem;
  }

  [class*='-message'] {
    font-weight: 500;
  }

  .error-message {
    color: #d33c40;
  }

  .success-message {
    color: #32a95d;
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
