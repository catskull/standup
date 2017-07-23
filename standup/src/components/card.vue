<template>
  <div class="card">
    <el-card class="box-card">
    <div slot="header" class="clearfix">
      <h2>Card name</h2>
      <!-- <el-button style="float: right;" type="primary">Operation button</el-button> -->
    </div>
    <div v-for="o in 4" :key="o" class="text item">
      {{'List item ' + o }}
    </div>
  </el-card>
  </div>
</template>

<script>
export default {
  name: 'card',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
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
  }
</style>
