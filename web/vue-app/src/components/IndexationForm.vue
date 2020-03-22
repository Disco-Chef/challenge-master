<template>
  <div id="indexation-form">
    <form @submit.prevent="handleSubmit">
      <div class="groups">
        <div class="group">
          <label>Contract Start Date:</label>
          <input
            ref="first"
            type="date"
            v-model="input.start"
            :class="{ 'has-error': (submitting && (emptyStart ||conceptError)) }"
            @focus="clearStatus"
            @keypress="clearStatus"
          />
        </div>
        <div class="group">
          <label>Contract Signed On:</label>
          <input
            type="date"
            v-model="input.signed"
            :class="{ 'has-error': (submitting && (emptySigned || farseerError || conceptError))}"
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
            :class="{ 'has-error': (submitting && (emptyRent || InvalidRent)) }"
            @focus="clearStatus"
          />
        </div>
        <div class="group">
          <label>Region (brussels, flanders, wallonia):</label>
          <input
            type="text"
            v-model="input.region"
            :class="{ 'has-error': (submitting && (emptyRegion ||invalidLocation)) }"
            @focus="clearStatus"
          />
        </div>
      </div>


      <br>
      <template v-if="submitting">
        <p v-if="lackOfInputError" class="error-message">
        ❗There seems to be some missing fields 😞
        </p>
        <p v-if="this.farseerError" class="error-message">❗Signed date is in the future from now</p>
        <p v-if="this.conceptError" class="error-message">❗Sign date cannot be in the future of the start date 😏 </p>
        <p v-if="this.invalidRent" class="error-message">❗Please input a numerical value for the rent 🔎 </p>
        <p v-if="this.invalidLocation" class="error-message">❗Region selection can only be one of three: brussels, flanders, wallonia </p>
      </template>
      <p v-if="success" class="success-message">
        ✅ Indexed rent successfully added
      </p>
      <br>
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
        lackOfInputError: false,
        success: false,
        conceptualError: false,
        oracleError: false,
        numbersError: false,
        regionError: false,
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

        if (this.emptyRent || this.emptyRegion || this.emptyStart || this.emptySigned) {
          this.lackOfInputError = true
          return
        }
        if (this.farseerError) {
          this.oracleError = true
          return
        }
        if (this.conceptError) {
          this.conceptualError = true
          return
        }
        if (this.invalidRent) {
          this.numbersError = true
          return
        }
        if (this.invalidLocation) {
          this.regionError = true
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
        this.lackOfInputError = false
        this.success = true
        this.submitting = false

      },

      clearStatus() {
        this.success = false
        this.lackOfInputError = false
      }
    },
    computed: {
      emptyStart() {
        return this.input.start === ''
      },
      emptySigned() {
        return this.input.signed === ''
      },
      emptyRent() {
        return this.input.rent === ''
      },
      emptyRegion() {
        return this.input.region === ''
      },
      farseerError() {
        return Date.parse(this.input.signed) > Date.today
      },
      conceptError() {
        return Date.parse(this.input.start) < Date.parse(this.input.signed)
      },
      invalidRent() {
        return isNaN(this.input.rent)
      },
      invalidLocation() {
        return !["brussels", "Brussels", "flanders", "Flanders", "wallonia", "Wallonia"].includes(this.input.region)
      }
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
