<template>
  <div id="app">
    <span v-if="events">
      <el-row v-for="chunk in events" :key="chunk[0].id" :gutter="20">
        <el-col v-for="event in chunk" :key="event.id" :md="6" :sm="24">
          <card :name="event.owner" :status="event.status"></card>
        </el-col>
      </el-row>
    </span>
  </div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'
import card from './components/card'

export default {
  name: 'app',

  data () {
    return {
      events: null
    }
  },

  created () {
    axios.get('https://peaceful-refuge-56771.herokuapp.com/')
    .then(
      response => {
        console.log(response)
        this.events = _.chunk(response.data, 4)
      },

      error => {
        console.log(error)
      }
    )
  },

  components: {
    card
  }
}
</script>

<style>
  html {
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
  }
</style>
