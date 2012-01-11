## Note: Draw-cut = Koiguchi no kiri kata
exports.techniques=
      name: 'Kirioshi'
      description: 'Downward straight cut.'
      type: 'cut'
      stops: []
      keycode: 49
,
      name: 'Mayoko Giri'
      description: 'Side cut, left to right.'
      type: 'cut'
      stops: ['Kirioshi']
      keycode: 50
,
      bane: 'Kesa Giri'
      description: 'Downward diagonal cut.'
      type: 'cut'
      stops: ['Tsuki', 'Mayoko_Giri']
      keycode: 51
,
      name: 'Kiriagi'
      description: 'Upward diagonal cut.'
      stops: ['Tsuki', 'Kirioshi']
      keycode: 52
,
      name: 'Tsuki'
      description: 'Straight thrust'
      stops: []
      keycode: 53