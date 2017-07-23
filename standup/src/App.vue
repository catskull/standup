<template>
  <div id="app">
    <el-row :gutter="20">
      <el-col :md="6" :sm="24"><card></card></el-col>
      <el-col :md="6" :sm="24"><card></card></el-col>
      <el-col :md="6" :sm="24"><card></card></el-col>
      <el-col :md="6" :sm="24"><card></card></el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'
import card from './components/card'

export default {
  name: 'app',
  components: {
    card
  },

  created () {
    console.log('hi')
    axios.get('http://peaceful-refuge-56771.herokuapp.com/')
    .then(
      response => {
        console.log(response)
      },

      error => {
        console.log(error)
      })
  }
}
</script>

<style>
  html {
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
  }
</style>
