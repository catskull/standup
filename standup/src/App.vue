<template>
  <div id="app">
    <span v-if="users">
      <el-row v-for="chunk in users" :key="chunk[0].id" :gutter="20">
        <el-col v-for="user in chunk" :key="user.id" :md="8" :sm="24">
          <card
            :name="user.name"
            :standing="user.standing"
            :timestamp="user.timestamp"
            :events="user.totals"
          ></card>
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
      users: null
    }
  },

  created () {
    axios.get('https://peaceful-refuge-56771.herokuapp.com/users')
    .then(
      response => {
        console.log(response)
        this.users = _.chunk(response.data, 3)
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
