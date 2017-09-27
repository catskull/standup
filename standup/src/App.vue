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
            :max="max"
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
      users: null,
      max: 0
    }
  },

  created () {
    axios.get('http://localhost:4567/users')
    .then(
      response => {
        let times = []
        _.forEach(response.data, (person) => {
          times.push(Object.values(person.totals))
        })
        times = _.flattenDeep(times)
        this.max = Math.round(_.max(times) / 60)
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
