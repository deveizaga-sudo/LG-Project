/* Static demo content. Swap with API calls / Luna service data as needed. */
var AppData = {
  rail: [
    { id: 'home', label: 'Home', icon: 'home' },
    { id: 'live', label: 'Live TV', icon: 'live' },
    { id: 'apps', label: 'Apps', icon: 'apps' },
    { id: 'inputs', label: 'Inputs', icon: 'input' },
    { id: 'search', label: 'Search', icon: 'search' },
    { id: 'settings', label: 'Settings', icon: 'settings' }
  ],

  featured: [
    {
      tag: 'New season',
      title: 'Northern Lights',
      meta: '2026 · Drama · 3 Seasons · 4K HDR',
      desc: 'A remote research station at the edge of the Arctic uncovers a signal that should not exist — and the crew must decide who to trust before the long night falls.',
      art: 'linear-gradient(135deg, #0f2027 0%, #203a43 45%, #2c5364 100%)'
    },
    {
      tag: 'Trending',
      title: 'Desert Run',
      meta: '2025 · Action · 2h 4m · Dolby Vision',
      desc: 'Three couriers race across an endless desert to deliver a package that could end a decades-long feud between rival cities.',
      art: 'linear-gradient(135deg, #3a1c0b 0%, #b5541c 55%, #f0a04b 100%)'
    },
    {
      tag: 'Live now',
      title: 'Ocean Worlds',
      meta: 'Nature · Episode 4 · 8K',
      desc: 'Dive into the deepest trenches on Earth and meet the creatures that thrive in total darkness.',
      art: 'linear-gradient(135deg, #001b44 0%, #00508f 55%, #00a6c0 100%)'
    }
  ],

  rows: [
    {
      title: 'Continue watching',
      type: 'wide',
      items: [
        { title: 'Northern Lights · S3 E2', progress: 64, art: 'linear-gradient(135deg,#0f2027,#2c5364)' },
        { title: 'Kitchen Masters', progress: 30, art: 'linear-gradient(135deg,#5f2c82,#49a09d)' },
        { title: 'The Long Game', progress: 85, art: 'linear-gradient(135deg,#232526,#5b6467)' },
        { title: 'City Nights', progress: 12, art: 'linear-gradient(135deg,#141e30,#243b55)' },
        { title: 'Wild Coast', progress: 50, art: 'linear-gradient(135deg,#134e5e,#71b280)' }
      ]
    },
    {
      title: 'Apps',
      type: 'app',
      items: [
        { title: 'Live TV', icon: 'live', art: 'linear-gradient(135deg,#e6007e,#ff4fa7)' },
        { title: 'Movies', icon: 'film', art: 'linear-gradient(135deg,#c31432,#240b36)' },
        { title: 'Music', icon: 'music', art: 'linear-gradient(135deg,#11998e,#38ef7d)' },
        { title: 'Gallery', icon: 'image', art: 'linear-gradient(135deg,#f7971e,#ffd200)' },
        { title: 'Browser', icon: 'globe', art: 'linear-gradient(135deg,#2193b0,#6dd5ed)' },
        { title: 'Sports', icon: 'trophy', art: 'linear-gradient(135deg,#1d4350,#a43931)' },
        { title: 'Games', icon: 'game', art: 'linear-gradient(135deg,#654ea3,#eaafc8)' },
        { title: 'Screen Share', icon: 'cast', art: 'linear-gradient(135deg,#373b44,#4286f4)' },
        { title: 'Store', icon: 'bag', art: 'linear-gradient(135deg,#ff512f,#dd2476)' }
      ]
    },
    {
      title: 'Recommended for you',
      type: 'poster',
      items: [
        { title: 'Desert Run', art: 'linear-gradient(160deg,#3a1c0b,#f0a04b)' },
        { title: 'Ocean Worlds', art: 'linear-gradient(160deg,#001b44,#00a6c0)' },
        { title: 'Midnight Signal', art: 'linear-gradient(160deg,#0f0c29,#302b63,#24243e)' },
        { title: 'Green Valley', art: 'linear-gradient(160deg,#0b3d0b,#56ab2f)' },
        { title: 'Neon District', art: 'linear-gradient(160deg,#41295a,#2f0743)' },
        { title: 'Summit', art: 'linear-gradient(160deg,#2c3e50,#bdc3c7)' },
        { title: 'Red Line', art: 'linear-gradient(160deg,#4b134f,#c94b4b)' },
        { title: 'Paper Planes', art: 'linear-gradient(160deg,#1e3c72,#2a5298)' },
        { title: 'Low Tide', art: 'linear-gradient(160deg,#0f3443,#34e89e)' }
      ]
    },
    {
      title: 'Inputs',
      type: 'input',
      items: [
        { title: 'HDMI 1', sub: 'Game console', icon: 'hdmi', live: true },
        { title: 'HDMI 2', sub: 'Set-top box', icon: 'hdmi', live: false },
        { title: 'HDMI 3 (eARC)', sub: 'Soundbar', icon: 'hdmi', live: true },
        { title: 'USB', sub: 'No device', icon: 'usb', live: false },
        { title: 'Antenna', sub: 'Broadcast', icon: 'antenna', live: true }
      ]
    }
  ]
};
