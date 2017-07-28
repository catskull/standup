import { Bar } from 'vue-chartjs'

export default Bar.extend({
  props: ['labels', 'data'],
  mounted () {
    // Overwriting base render method with actual data.
    this.renderChart({
      labels: this.labels,
      datasets: [
        {
          label: 'Time (minutes)',
          backgroundColor: '#20A0FF',
          data: this.data
        }
      ]
    },
      {
        legend: {
          display: false
        },
        scales: {
          xAxis: [{
            barPercentage: 1
          }]
        }
      }
  )
  }
})
