import { Bar } from 'vue-chartjs'

export default Bar.extend({
  props: ['labels', 'data', 'max'],
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
        scales: {
          yAxes: [{
            ticks: {
              stepSize: 10,
              max: this.max
            }
          }]
        },
        legend: {
          display: false
        },
        animation: {
          duration: 0
        }
      }
  )
  }
})
