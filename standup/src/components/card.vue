<template>
  <div class="card">
    <el-card class="box-card">
    <div slot="header" class="clearfix">
      <h2>{{name}}</h2>
      <!-- <el-button style="float: right;" type="primary">Operation button</el-button> -->
    </div>
    <p>{{name}} is {{status}}</p>
  </el-card>
  </div>
</template>

<script>
export default {
  name: 'card',

  props: ['name', 'status'],

  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  },

  created () {
    console.log(this.name)
  }
}
</script>

<style scoped>
  h2 {
    line-height: 36px;
    display: inline;
    font-weight: 400;
  }

  .box-card {
    /*width: 480px;*/
    margin-bottom: 10px;
  }
</style>
