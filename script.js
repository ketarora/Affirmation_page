/* ★═══════════════════════════════════════════════════════★
   NishAffs 🌸 App Logic
   Splash, navigation, affirmations CRUD, book reader
   ★═══════════════════════════════════════════════════════★ */
(function () {
  'use strict';

  // ═══ DATA ═══
  const SPLASH_AFFS = [
    "You are exactly where you need to be. 🌸",
    "The universe has beautiful plans for you. ✨",
    "You are worthy of all the love in this world. 💖",
    "Everything is working out in your favor. 🦋",
    "You attract what you believe. Believe in magic. 🌈",
    "Today is a beautiful day to manifest your dreams. 🌻",
    "You are powerful beyond measure. 🌷",
    "Good things are flowing towards you right now. 🐧"
  ];

  const DAILY_AFFS = [
    "The universe is always listening. Trust the process. ✨",
    "I am a magnet for abundance, love, and joy. 💖",
    "Everything I desire is already on its way to me. 🌈",
    "I release all doubts and embrace my worthiness. 🦋",
    "I am grateful for every blessing in my life. 🌸",
    "My energy radiates positivity and attracts miracles. 🌻",
    "I choose to see the beauty in every moment. 🌷"
  ];

  const PRELOADED = [
    { text: "I am worthy of love and kindness. 💖", cat: "love" },
    { text: "I trust my journey and embrace every step. 🦋", cat: "love" },
    { text: "My confidence grows stronger every single day. 🌸", cat: "love" },
    { text: "I am beautiful inside and out. ✨", cat: "love" },
    { text: "I attract success with every thought I think. 💼", cat: "career" },
    { text: "My work creates positive impact in the world. 🌟", cat: "career" },
    { text: "Opportunities flow to me in abundance. 🌈", cat: "career" },
    { text: "My body is healthy, my mind is peaceful. 🌿", cat: "health" },
    { text: "I nourish my body with love and healthy choices. 🍃", cat: "health" },
    { text: "Abundance flows to me from expected and unexpected sources. 🌟", cat: "wealth" },
    { text: "I am a magnet for financial prosperity. ✨", cat: "wealth" },
    { text: "Money comes to me easily and effortlessly. 💫", cat: "wealth" },
    { text: "I am grateful for this beautiful life. 🙏", cat: "gratitude" },
    { text: "Thank you, Universe, for everything. 🌸", cat: "gratitude" },
    { text: "Every day brings new reasons to be grateful. 🌻", cat: "gratitude" }
  ];

  const BOOKS = [
    {
      title: "The Secret of Manifestation",
      author: "NishAffs Library",
      cover: "book-cover--1",
      emoji: "🌸",
      pages: [
        { title: "What is Manifestation?", body: "Manifestation is the practice of thinking aspirational thoughts with the purpose of making them real. It's about aligning your energy, thoughts, and beliefs with what you truly desire.\n\nThe Law of Attraction states that like attracts like. When you focus on positive thoughts, you attract positive experiences into your life.\n\nThis isn't about wishful thinking — it's about becoming an energetic match for your desires through consistent practice, belief, and action." },
        { title: "The Power of Belief", body: "Your beliefs shape your reality. If you believe you are worthy of love, abundance, and success — the universe conspires to make it so.\n\nStart by examining your current beliefs. Are they serving you? Or are they holding you back?\n\nReplace limiting beliefs like 'I'm not good enough' with empowering ones like 'I am more than enough.' This simple shift changes everything." },
        { title: "Visualization Techniques", body: "Close your eyes and see your dream life in vivid detail. What does your dream home look like? How does success feel?\n\nVisualization activates the same neural networks as actually performing the action. Your brain doesn't know the difference between imagination and reality.\n\nPractice for 5-10 minutes daily. See it. Feel it. Believe it. Become it. 🌈" },
        { title: "Gratitude Practice", body: "Gratitude is the highest vibration you can emit. When you're grateful for what you have, you attract more things to be grateful for.\n\nStart a gratitude journal. Write 3 things you're grateful for every morning.\n\nSay 'Thank you' to the universe for everything — even the challenges, because they're teaching you something beautiful. 🙏" },
        { title: "Taking Inspired Action", body: "Manifestation isn't just thinking and waiting. It's about taking inspired action — steps that feel aligned with your purpose.\n\nWhen an opportunity feels right in your gut, take it. When a door opens, walk through it.\n\nThe universe rewards those who move towards their dreams with faith and courage. You've got this! ✨" }
      ]
    },
    {
      title: "Self-Love Affirmations",
      author: "NishAffs Library",
      cover: "book-cover--2",
      emoji: "💖",
      pages: [
        { title: "Why Self-Love Matters", body: "Self-love is the foundation of every manifestation. You cannot attract what you don't believe you deserve.\n\nWhen you love yourself deeply, you set the standard for how the universe treats you. You become a magnet for love, respect, and abundance.\n\nSelf-love isn't selfish — it's necessary. Pour into your own cup first. 💖" },
        { title: "Mirror Work", body: "Stand in front of a mirror. Look into your own eyes. Say: 'I love you. I really, really love you.'\n\nIt might feel awkward at first — that's normal. Keep doing it. Day after day.\n\nLouise Hay, the queen of affirmations, swore by mirror work. It's transformative because you're speaking directly to your subconscious mind. 🪞" },
        { title: "Daily Self-Love Ritual", body: "Every morning, before looking at your phone:\n\n1. Take 3 deep breaths 🌸\n2. Place your hand on your heart\n3. Say: 'I am enough. I am loved. I am worthy.'\n4. Smile at yourself\n\nThis 60-second ritual rewires your brain for self-compassion and sets the tone for your entire day." },
        { title: "Releasing Comparison", body: "Social media makes it easy to compare. But comparison is the thief of joy.\n\nRemember: you're seeing someone's highlight reel, not their behind-the-scenes. Everyone has struggles.\n\nYour journey is unique. Your timeline is perfect. Trust that everything is unfolding exactly as it should. 🦋" }
      ]
    },
    {
      title: "Abundance Mindset",
      author: "NishAffs Library",
      cover: "book-cover--3",
      emoji: "🌟",
      pages: [
        { title: "Scarcity vs Abundance", body: "Most of us were raised with a scarcity mindset: 'There's not enough.' 'Money doesn't grow on trees.' 'Life is hard.'\n\nAn abundance mindset says: 'There's more than enough for everyone.' 'Opportunities are infinite.' 'I am a magnet for prosperity.'\n\nWhich reality do you want to live in? 🌟" },
        { title: "Money Affirmations", body: "Money is energy. When you have a positive relationship with money, more of it flows to you.\n\nRepeat daily:\n• 'Money flows to me easily and effortlessly.'\n• 'I am worthy of financial abundance.'\n• 'Every rupee I spend comes back to me multiplied.'\n\nFeel the truth of these words. Money loves gratitude. 💫" },
        { title: "Giving and Receiving", body: "The universe operates on a cycle of giving and receiving. When you give freely — whether it's your time, love, or resources — you create space to receive.\n\nDon't hold on too tightly. Let abundance flow through you.\n\nBe generous with compliments, kindness, and support. What you give, you receive tenfold. 🌈" }
      ]
    },
    {
      title: "Spiritual Awakening",
      author: "NishAffs Library",
      cover: "book-cover--4",
      emoji: "🦋",
      pages: [
        { title: "Signs of Awakening", body: "A spiritual awakening isn't always dramatic. Sometimes it starts as a quiet knowing — a feeling that there's more to life than what meets the eye.\n\nSigns include:\n• Seeing repeating numbers (111, 222, 333)\n• Feeling drawn to nature\n• Questioning old beliefs\n• Wanting deeper connections\n• Increased empathy and intuition 🦋" },
        { title: "Connecting with the Universe", body: "The universe communicates with you constantly — through synchronicities, dreams, gut feelings, and signs.\n\nTo hear its messages:\n1. Quiet your mind through meditation 🧘‍♀️\n2. Spend time in nature 🌿\n3. Journal your thoughts and dreams ✍️\n4. Trust your intuition\n\nThe more you tune in, the louder the guidance becomes." },
        { title: "Your Higher Self", body: "Your higher self is the wisest version of you — the version that sees the bigger picture and knows your soul's purpose.\n\nConnect with your higher self by asking: 'What would my highest self do in this situation?'\n\nLet this version of you guide your decisions. She/he already knows the way. ✨" }
      ]
    },
    {
      title: "Daily Rituals for Joy",
      author: "NishAffs Library",
      cover: "book-cover--5",
      emoji: "🌻",
      pages: [
        { title: "Morning Magic", body: "How you start your morning sets the vibration for your entire day.\n\nA magical morning routine:\n☀️ Wake up grateful\n💧 Drink warm water with intention\n📖 Read 1 page of an inspiring book\n🌸 Say your affirmations\n🎵 Listen to high-vibe music\n\nDo this for 21 days and watch your life transform." },
        { title: "The 5-4-3-2-1 Grounding", body: "When anxiety creeps in, ground yourself:\n\n5 things you can SEE 👀\n4 things you can TOUCH ✋\n3 things you can HEAR 👂\n2 things you can SMELL 👃\n1 thing you can TASTE 👅\n\nThis brings you back to the present moment — where magic happens. 🌈" },
        { title: "Evening Reflection", body: "Before sleep, reflect on your day:\n\n🌙 What went well today?\n💖 What am I grateful for?\n✨ What did I manifest today?\n🌸 How can I be even better tomorrow?\n\nEnd your day with love and gratitude. Your subconscious mind processes these positive thoughts while you sleep, creating new neural pathways for joy. Sweet dreams! 💫" }
      ]
    }
  ];

  // ═══ STORAGE ═══
  function getCustomAffs() {
    return JSON.parse(localStorage.getItem('nishaffs_custom') || '[]');
  }
  function saveCustomAffs(list) {
    localStorage.setItem('nishaffs_custom', JSON.stringify(list));
  }
  function getFavs() {
    return JSON.parse(localStorage.getItem('nishaffs_favs') || '[]');
  }
  function saveFavs(list) {
    localStorage.setItem('nishaffs_favs', JSON.stringify(list));
  }

  // ═══ SPLASH ═══
  const splash = document.getElementById('splash');
  const app = document.getElementById('app');
  document.getElementById('splashAff').textContent = SPLASH_AFFS[Math.floor(Math.random() * SPLASH_AFFS.length)];

  setTimeout(() => {
    splash.classList.add('hide');
    app.classList.add('show');
  }, 2800);

  // ═══ GREETING ═══
  const now = new Date();
  const hours = now.getHours();
  let greet = hours < 12 ? 'Good Morning 🌸' : hours < 17 ? 'Good Afternoon 🌻' : 'Good Evening 🌙';
  document.getElementById('greeting').textContent = greet;
  document.getElementById('dateText').textContent = now.toLocaleDateString('en-IN', { month: 'long', day: 'numeric', year: 'numeric' });

  // Daily affirmation
  const dayIndex = now.getDate() % DAILY_AFFS.length;
  document.getElementById('dailyAff').textContent = DAILY_AFFS[dayIndex];

  // ═══ NAVIGATION ═══
  const screens = document.querySelectorAll('.screen');
  const bnavs = document.querySelectorAll('.bnav');

  function switchScreen(id) {
    screens.forEach(s => s.classList.remove('active'));
    bnavs.forEach(b => b.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    document.querySelector(`[data-screen="${id}"]`).classList.add('active');
    if (id === 'screenAff') renderMyAffs();
    if (id === 'screenProfile') updateStats();
  }

  bnavs.forEach(b => b.addEventListener('click', () => switchScreen(b.dataset.screen)));

  // ═══ CATEGORIES ═══
  let currentCat = 'all';
  const catBtns = document.querySelectorAll('.cat');
  catBtns.forEach(b => b.addEventListener('click', () => {
    catBtns.forEach(c => c.classList.remove('active'));
    b.classList.add('active');
    currentCat = b.dataset.cat;
    renderPreloaded();
  }));

  // ═══ RENDER PRELOADED ═══
  const affList = document.getElementById('affList');
  const favs = getFavs();

  function renderPreloaded() {
    const filtered = currentCat === 'all' ? PRELOADED : PRELOADED.filter(a => a.cat === currentCat);
    affList.innerHTML = filtered.map((a, i) => {
      const isFav = favs.includes(a.text);
      return `<div class="aff-card" data-cat="${a.cat}">
        <p class="aff-card-text">${a.text}</p>
        <span class="aff-card-cat">${getCatLabel(a.cat)}</span>
        <span class="aff-card-fav ${isFav ? 'fav' : ''}" data-aff="${encodeURIComponent(a.text)}">${isFav ? '💖' : '🤍'}</span>
      </div>`;
    }).join('');

    affList.querySelectorAll('.aff-card-fav').forEach(f => {
      f.addEventListener('click', () => {
        const txt = decodeURIComponent(f.dataset.aff);
        const idx = favs.indexOf(txt);
        if (idx >= 0) { favs.splice(idx, 1); f.textContent = '🤍'; f.classList.remove('fav'); }
        else { favs.push(txt); f.textContent = '💖'; f.classList.add('fav'); }
        saveFavs(favs);
      });
    });
  }

  function getCatLabel(c) {
    const map = { love: '💖 Self Love', career: '💼 Career', health: '🌿 Health', wealth: '🌟 Wealth', gratitude: '🙏 Gratitude' };
    return map[c] || c;
  }

  renderPreloaded();

  // ═══ CREATE MODAL ═══
  const createModal = document.getElementById('createModal');
  const affInput = document.getElementById('affInput');
  const affCategory = document.getElementById('affCategory');

  document.getElementById('createBtn').addEventListener('click', () => createModal.classList.add('open'));
  document.getElementById('cancelAff').addEventListener('click', () => { createModal.classList.remove('open'); affInput.value = ''; });
  createModal.querySelector('.modal-overlay').addEventListener('click', () => { createModal.classList.remove('open'); affInput.value = ''; });

  document.getElementById('saveAff').addEventListener('click', () => {
    const text = affInput.value.trim();
    if (!text) return;
    const list = getCustomAffs();
    list.unshift({ text, cat: affCategory.value, id: Date.now() });
    saveCustomAffs(list);
    affInput.value = '';
    createModal.classList.remove('open');
    renderPreloaded();
  });

  // ═══ MY AFFIRMATIONS ═══
  function renderMyAffs() {
    const list = getCustomAffs();
    const container = document.getElementById('myAffList');
    const empty = document.getElementById('emptyState');

    if (list.length === 0) {
      container.innerHTML = '';
      empty.style.display = 'block';
      return;
    }

    empty.style.display = 'none';
    container.innerHTML = list.map(a => `<div class="my-aff-card">
      <div class="my-aff-card-body">
        <p class="my-aff-card-text">${a.text}</p>
        <span class="my-aff-card-cat">${getCatLabel(a.cat)}</span>
      </div>
      <button class="my-aff-delete" data-id="${a.id}">✕</button>
    </div>`).join('');

    container.querySelectorAll('.my-aff-delete').forEach(btn => {
      btn.addEventListener('click', () => {
        const list = getCustomAffs().filter(a => a.id !== parseInt(btn.dataset.id));
        saveCustomAffs(list);
        renderMyAffs();
      });
    });
  }

  // ═══ BOOKS ═══
  const bookGrid = document.getElementById('bookGrid');
  bookGrid.innerHTML = BOOKS.map((b, i) => `<div class="book-card" data-book="${i}">
    <div class="book-cover ${b.cover}">${b.emoji}</div>
    <div class="book-info"><h3>${b.title}</h3><p>${b.author}</p></div>
  </div>`).join('');

  // ═══ READER ═══
  const reader = document.getElementById('reader');
  const readerPages = document.getElementById('readerPages');
  const readerTitle = document.getElementById('readerTitle');
  const readerPageNum = document.getElementById('readerPage');
  let currentPage = 0;
  let totalPages = 0;

  bookGrid.querySelectorAll('.book-card').forEach(card => {
    card.addEventListener('click', () => {
      const book = BOOKS[parseInt(card.dataset.book)];
      openReader(book);
    });
  });

  function openReader(book) {
    readerTitle.textContent = book.title;
    currentPage = 0;
    totalPages = book.pages.length;
    readerPages.innerHTML = book.pages.map(p => `<div class="reader-page-item">
      <h3>${p.title}</h3>
      <p>${p.body.replace(/\n/g, '<br/>')}</p>
    </div>`).join('');
    updateReaderPage();
    reader.classList.add('open');
  }

  function updateReaderPage() {
    readerPages.style.transform = `translateX(-${currentPage * 100}%)`;
    readerPageNum.textContent = `${currentPage + 1}/${totalPages}`;
  }

  document.getElementById('readerBack').addEventListener('click', () => reader.classList.remove('open'));

  // Swipe for reader
  let touchStartX = 0;
  const readerBody = document.getElementById('readerBody');
  readerBody.addEventListener('touchstart', e => { touchStartX = e.touches[0].clientX; }, { passive: true });
  readerBody.addEventListener('touchend', e => {
    const diff = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) {
      if (diff > 0 && currentPage < totalPages - 1) currentPage++;
      else if (diff < 0 && currentPage > 0) currentPage--;
      updateReaderPage();
    }
  });

  // Mouse swipe for desktop testing
  let mouseDown = false, mouseStartX = 0;
  readerBody.addEventListener('mousedown', e => { mouseDown = true; mouseStartX = e.clientX; });
  readerBody.addEventListener('mouseup', e => {
    if (!mouseDown) return;
    mouseDown = false;
    const diff = mouseStartX - e.clientX;
    if (Math.abs(diff) > 50) {
      if (diff > 0 && currentPage < totalPages - 1) currentPage++;
      else if (diff < 0 && currentPage > 0) currentPage--;
      updateReaderPage();
    }
  });

  // ═══ PROFILE ═══
  function updateStats() {
    document.getElementById('statCustom').textContent = getCustomAffs().length;
    document.getElementById('statFav').textContent = getFavs().length;
  }

  // Toggle
  document.getElementById('toggleReminder')?.addEventListener('click', function () {
    this.classList.toggle('active');
  });

})();
