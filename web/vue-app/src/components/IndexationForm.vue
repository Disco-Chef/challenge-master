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
            :class="{ 'has-error': (submitting && (emptyStart ||conceptError)) }"
            @focus="clearStatus"
            @keypress="clearStatus"
          />
        </div>
        <div class="group">
          <label>Contract Signed On:</label>
          <input
            type="text"
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
      <p v-if="lackOfInputError && submitting" class="error-message">
        ❗There seems to be some missing fields 😞
      </p>
      <p v-if="this.farseerError && submitting" class="error-message">❗One of your your signed date is in the future</p>
      <p v-if="this.conceptError && submitting" class="error-message">❗Sign date cannot be in the future of the start date 😏 </p>
      <p v-if="this.invalidRent && submitting" class="error-message">❗Please input a numerical value for the rent 🔎 </p>
      <p v-if="this.invalidLocation && submitting" class="error-message">❗Region selection can only be one of three: brussels, flanders, wallonia </p>
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
        return this.input.region != ("brussels" || "flanders" || "wallonia")
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
