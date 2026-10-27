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

  // No ads: the home screen shows only the viewer's own content, apps and
  // inputs. There are no promoted titles, recommendations or sponsored
  // tiles, and app.js drops any item flagged `sponsored` or `promoted`.
  rows: [
    {
      title: 'Continue watching',
      type: 'wide',
      items: [
        {
          title: 'Northern Lights · S3 E2',
          progress: 64,
          meta: 'Season 3 · Episode 2 · 22 min left',
          desc: 'A remote research station at the edge of the Arctic uncovers a signal that should not exist — and the crew must decide who to trust before the long night falls.',
          art: 'linear-gradient(135deg,#0f2027,#2c5364)'
        },
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
