import { Controller } from "@hotwired/stimulus"

const CHART_DEFAULTS = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      labels: {
        color: "#475569",
        font: {
          family: "'Trebuchet MS', 'Segoe UI', sans-serif",
          size: 12
        }
      }
    },
    tooltip: {
      backgroundColor: "rgba(15, 23, 42, 0.92)",
      titleColor: "#f8fafc",
      bodyColor: "#e2e8f0",
      padding: 12,
      cornerRadius: 12
    }
  }
}

export default class extends Controller {
  static targets = [
    "trendCanvas",
    "categoryCanvas",
    "statusCanvas",
    "priceCanvas",
    "communityCanvas",
    "rangeButton",
    "trendTypeButton",
    "categoryData",
    "statusData",
    "priceBandsData",
    "communitiesData",
    "dailyPostsData"
  ]

  connect() {
    this.Chart = window.Chart
    this.currentRange = 7
    this.currentTrendType = "line"
    this.charts = {}
    this.datasets = {
      category: this.parseDataset(this.categoryDataTarget),
      status: this.parseDataset(this.statusDataTarget),
      priceBands: this.parseDataset(this.priceBandsDataTarget),
      communities: this.parseDataset(this.communitiesDataTarget),
      dailyPosts: this.parseDataset(this.dailyPostsDataTarget)
    }

    if (!this.Chart) {
      this.retryOnLoad = () => {
        this.Chart = window.Chart

        if (this.Chart) {
          this.initializeDashboard()
        } else {
          console.error("Chart.js failed to load for analytics dashboard")
        }
      }

      window.addEventListener("load", this.retryOnLoad, { once: true })
      return
    }

    this.initializeDashboard()
  }

  disconnect() {
    if (this.retryOnLoad) {
      window.removeEventListener("load", this.retryOnLoad)
      this.retryOnLoad = null
    }

    Object.values(this.charts).forEach((chart) => chart.destroy())
  }

  setRange(event) {
    this.currentRange = Number(event.params.days)
    this.renderTrendChart()
    this.syncControls()
  }

  setTrendType(event) {
    this.currentTrendType = event.params.kind
    this.renderTrendChart()
    this.syncControls()
  }

  renderCharts() {
    this.renderTrendChart()
    this.renderCategoryChart()
    this.renderStatusChart()
    this.renderPriceChart()
    this.renderCommunityChart()
  }

  initializeDashboard() {
    if (!this.hasValidDataset(this.datasets.category) ||
      !this.hasValidDataset(this.datasets.status) ||
      !this.hasValidDataset(this.datasets.priceBands) ||
      !this.hasValidDataset(this.datasets.communities) ||
      !this.hasValidDataset(this.datasets.dailyPosts)) {
      console.error("Analytics dashboard received invalid chart data", {
        category: this.datasets.category,
        status: this.datasets.status,
        priceBands: this.datasets.priceBands,
        communities: this.datasets.communities,
        dailyPosts: this.datasets.dailyPosts
      })
      return
    }

    this.renderCharts()
    this.syncControls()
  }

  renderTrendChart() {
    const slicedData = this.sliceSeries(this.datasets.dailyPosts, this.currentRange)

    this.replaceChart("trend", this.trendCanvasTarget, {
      type: this.currentTrendType,
      data: {
        labels: slicedData.labels,
        datasets: [
          {
            label: "New listings",
            data: slicedData.values,
            borderColor: "#0f766e",
            backgroundColor: this.currentTrendType === "line" ? "rgba(20, 184, 166, 0.18)" : "#14b8a6",
            fill: this.currentTrendType === "line",
            tension: 0.35,
            borderWidth: 3,
            pointRadius: 4,
            pointHoverRadius: 6
          }
        ]
      },
      options: {
        ...CHART_DEFAULTS,
        scales: {
          x: {
            ticks: { color: "#64748b" },
            grid: { display: false }
          },
          y: {
            beginAtZero: true,
            ticks: {
              color: "#64748b",
              precision: 0
            },
            grid: {
              color: "rgba(148, 163, 184, 0.18)"
            }
          }
        }
      }
    })
  }

  renderCategoryChart() {
    this.replaceChart("category", this.categoryCanvasTarget, {
      type: "doughnut",
      data: {
        labels: this.datasets.category.labels,
        datasets: [
          {
            data: this.datasets.category.values,
            backgroundColor: ["#0f766e", "#0ea5e9", "#f59e0b", "#f97316", "#8b5cf6", "#ef4444"],
            borderWidth: 0,
            hoverOffset: 10
          }
        ]
      },
      options: {
        ...CHART_DEFAULTS,
        cutout: "62%"
      }
    })
  }

  renderStatusChart() {
    this.replaceChart("status", this.statusCanvasTarget, {
      type: "bar",
      data: {
        labels: this.datasets.status.labels,
        datasets: [
          {
            label: "Listings",
            data: this.datasets.status.values,
            backgroundColor: ["#10b981", "#f59e0b", "#ef4444"],
            borderRadius: 14,
            maxBarThickness: 56
          }
        ]
      },
      options: {
        ...CHART_DEFAULTS,
        plugins: {
          ...CHART_DEFAULTS.plugins,
          legend: { display: false }
        },
        scales: {
          x: {
            ticks: { color: "#64748b" },
            grid: { display: false }
          },
          y: {
            beginAtZero: true,
            ticks: { color: "#64748b", precision: 0 },
            grid: { color: "rgba(148, 163, 184, 0.18)" }
          }
        }
      }
    })
  }

  renderPriceChart() {
    this.replaceChart("price", this.priceCanvasTarget, {
      type: "bar",
      data: {
        labels: this.datasets.priceBands.labels,
        datasets: [
          {
            label: "Items",
            data: this.datasets.priceBands.values,
            backgroundColor: "#1d4ed8",
            borderRadius: 14,
            maxBarThickness: 52
          }
        ]
      },
      options: {
        ...CHART_DEFAULTS,
        indexAxis: "y",
        plugins: {
          ...CHART_DEFAULTS.plugins,
          legend: { display: false }
        },
        scales: {
          x: {
            beginAtZero: true,
            ticks: { color: "#64748b", precision: 0 },
            grid: { color: "rgba(148, 163, 184, 0.18)" }
          },
          y: {
            ticks: { color: "#64748b" },
            grid: { display: false }
          }
        }
      }
    })
  }

  renderCommunityChart() {
    this.replaceChart("community", this.communityCanvasTarget, {
      type: "polarArea",
      data: {
        labels: this.datasets.communities.labels,
        datasets: [
          {
            data: this.datasets.communities.values,
            backgroundColor: [
              "rgba(14, 165, 233, 0.78)",
              "rgba(20, 184, 166, 0.78)",
              "rgba(249, 115, 22, 0.78)",
              "rgba(168, 85, 247, 0.78)",
              "rgba(239, 68, 68, 0.78)"
            ],
            borderWidth: 0
          }
        ]
      },
      options: {
        ...CHART_DEFAULTS,
        scales: {
          r: {
            beginAtZero: true,
            ticks: {
              color: "#64748b",
              precision: 0,
              backdropColor: "transparent"
            },
            grid: { color: "rgba(148, 163, 184, 0.2)" },
            angleLines: { color: "rgba(148, 163, 184, 0.2)" }
          }
        }
      }
    })
  }

  replaceChart(key, canvas, config) {
    this.charts[key]?.destroy()
    this.charts[key] = new this.Chart(canvas, config)
  }

  sliceSeries(series, days) {
    return {
      labels: series.labels.slice(-days),
      values: series.values.slice(-days)
    }
  }

  syncControls() {
    this.rangeButtonTargets.forEach((button) => {
      const isActive = Number(button.dataset.days) === this.currentRange
      button.classList.toggle("is-active", isActive)
      button.setAttribute("aria-pressed", isActive ? "true" : "false")
    })

    this.trendTypeButtonTargets.forEach((button) => {
      const isActive = button.dataset.kind === this.currentTrendType
      button.classList.toggle("is-active", isActive)
      button.setAttribute("aria-pressed", isActive ? "true" : "false")
    })
  }

  hasValidDataset(dataset) {
    return dataset &&
      Array.isArray(dataset.labels) &&
      Array.isArray(dataset.values)
  }

  parseDataset(element) {
    try {
      return JSON.parse(element.textContent)
    } catch (error) {
      console.error("Failed to parse analytics dataset", error, element?.textContent)
      return null
    }
  }
}
