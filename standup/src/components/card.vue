<template>
  <div class="card">
    <el-card class="box-card" :class="status">
    <div slot="header" class="clearfix">
      <h2>{{name}}</h2>
      <p class="status">is {{status}}</p>
      <p class="status updated">{{timeAgo}}</p>
    </div>
    <chart
      :labels="labels"
      :data="data"
      :height="200"
      :max="max"
    ></chart>
  </el-card>
  </div>
</template>

<script>
import moment from 'moment'
import _ from 'lodash'
import chart from './chart'

export default {
  name: 'card',

  props: ['name', 'standing', 'timestamp', 'events', 'max'],

  data () {
    return {
      timeAgo: '',
      status: '',
      labels: [],
      data: []
    }
  },

  created () {
    this.timeAgo = moment(this.timestamp).fromNow()
    if (this.timeAgo === 'a few seconds ago') {
      this.timeAgo = 'just now'
    }

    if (this.standing) {
      this.status = 'standing'
    } else if (!this.standing) {
      this.status = 'sitting'
    }

    _.forEach(Object.keys(this.events), (value) => {
      this.labels.push(moment(value).format('dddd'))
    })

    _.forEach(Object.values(this.events), (value) => {
      this.data.push(Math.round(value / 60))
    })
  },

  components: {
    chart
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
    margin-bottom: 10px;
  }

  .standing {
    border-color: #20A0FF;
  }

  .sitting {
    border-color: #F7BA2A;
  }

  .status {
    margin: 0;
    color: #8492A6;
    display: inline;
  }

  .updated {
    float: right;
    margin-top: 16px;
    font-size: 13px;
  }
</style>
