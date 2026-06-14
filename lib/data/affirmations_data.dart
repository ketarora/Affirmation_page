// ════════════════════════════════════════════════════════════════════
//  AFFIRMATIONS DATA — Production Ready
//  Structured by mood & category
//  Hindi/English bilingual
// ════════════════════════════════════════════════════════════════════

class AffirmationCategory {
  final String name;
  final String nameHi;
  final String emoji;
  final String description;
  final String descriptionHi;
  final List<String> entries;
  final List<String> entriesHi;

  int get count => entries.length;

  AffirmationCategory({
    required this.name,
    required this.nameHi,
    required this.emoji,
    required this.entries,
    required this.entriesHi,
    this.description = '',
    this.descriptionHi = '',
  });
}

// ════════════════════════════════════════════════════════════════════
//  MOOD-BASED RECOMMENDATIONS
// ════════════════════════════════════════════════════════════════════

class MoodData {
  final String moodName;
  final String emoji;
  final String recommendedFrequency; // e.g., "396Hz - Fear Clearing"
  final String recommendedMeditation;
  final String journalPrompt;
  final String dailyAction;

  MoodData({
    required this.moodName,
    required this.emoji,
    required this.recommendedFrequency,
    required this.recommendedMeditation,
    required this.journalPrompt,
    required this.dailyAction,
  });
}

final moodRecommendations = [
  MoodData(
    moodName: "Low Vibe",
    emoji: "💫",
    recommendedFrequency: "396Hz - Fear Clearing",
    recommendedMeditation: "Gentle Rain Meditation - 10min",
    journalPrompt: "What would make you feel safer today?",
    dailyAction: "Take 5 deep breaths in sunlight",
  ),
  MoodData(
    moodName: "Meh",
    emoji: "🌙",
    recommendedFrequency: "432Hz - Heart Healing",
    recommendedMeditation: "Gratitude Meditation - 7min",
    journalPrompt: "What's one small thing to appreciate?",
    dailyAction: "Text someone you care about",
  ),
  MoodData(
    moodName: "Good",
    emoji: "🌟",
    recommendedFrequency: "528Hz - Transformation",
    recommendedMeditation: "Focus Flow Meditation - 15min",
    journalPrompt: "What are you building towards?",
    dailyAction: "Move your body for 10 minutes",
  ),
  MoodData(
    moodName: "Happy",
    emoji: "✨",
    recommendedFrequency: "639Hz - Connection",
    recommendedMeditation: "Abundance Meditation - 12min",
    journalPrompt: "Who deserves your joy today?",
    dailyAction: "Do something that makes you smile",
  ),
  MoodData(
    moodName: "Glowing",
    emoji: "🌈",
    recommendedFrequency: "852Hz - Intuition Awakening",
    recommendedMeditation: "Transcendence Meditation - 20min",
    journalPrompt: "What miracles are you manifesting?",
    dailyAction: "Share your energy with others",
  ),
];

// ════════════════════════════════════════════════════════════════════
//  AFFIRMATION CATEGORIES
// ════════════════════════════════════════════════════════════════════

final kAffCategories = [
  AffirmationCategory(
    name: "Inner Peace",
    nameHi: "आंतरिक शांति",
    emoji: "🧘‍♀️",
    entries: [
      "I choose peace over pressure 🌙",
      "My mind is calm and clear ✨",
      "Peace flows through me effortlessly 🌊",
      "I am safe in this moment ☁️",
      "I release what I cannot control 🌿",
      "I let life unfold gently 💫",
      "I breathe in calm energy 🌸",
      "My soul feels light and free 🕊️",
      "I return to peace easily 🌙",
      "I trust the timing of my life ✨",
      "My thoughts do not control me 🌿",
      "I let go of overthinking ☁️",
      "I am bigger than my fears 💖",
      "My nervous system feels safe 🌸",
      "I slow down and breathe 🌙",
      "I release mental noise ✨",
      "I do not need all the answers 🌊",
      "I am grounded in the present 🌿",
      "Everything is working out peacefully 💫",
      "I allow myself to relax ☁️",
      "I deserve a peaceful life 🌸",
      "I protect my inner calm 🌙",
      "I let peace fill my heart 💖",
      "I soften into stillness ☁️",
      "I am healing gently 🌿",
      "Calmness comes naturally to me ✨",
      "I feel emotionally safe 🌸",
      "I release heavy energy 🌊",
      "I rest without guilt 🕊️",
      "Peace is my natural state 💫",
      "I no longer carry emotional weight ☁️",
      "I let go and feel lighter 🌙",
      "My heart is at peace 💖",
      "I release the past softly 🌿",
      "I forgive myself completely ✨",
      "I am free from emotional chaos 🌸",
      "I choose calm over conflict 🌊",
      "I allow myself to feel safe again ☁️",
      "I welcome softness into my life 💫",
      "I am no longer fighting myself 🌙",
      "I trust the universe completely ✨",
      "Life is unfolding beautifully for me 🌸",
      "I am aligned with peace 🌿",
      "My energy feels balanced 🌊",
      "I am deeply connected to myself 💖",
      "I trust where life is taking me ☁️",
      "I surrender with peace 🌙",
      "I am guided and protected ✨",
      "I let peace lead my life 🌸",
      "Everything is okay for me now 💫",
    ],
    entriesHi: [],
  ),
  AffirmationCategory(
    name: "Level Up",
    nameHi: "आगे बढ़ो",
    emoji: "⚡",
    entries: [
      "I am becoming the strongest version of myself every day 🚀",
      "My life is expanding in beautiful and powerful ways ✨",
      "I trust the process of leveling up completely 🌙",
      "I deserve success that changes my entire life 💫",
      "I am stepping into a higher version of myself 🌸",
      "Every day I become more confident and focused 💖",
      "I attract opportunities that elevate my future 🌿",
      "My growth is unstoppable and inspiring ☀️",
      "I am building a life that feels exciting and meaningful 🚀",
      "I release the old version of myself with gratitude ✨",
      "I deserve a life filled with abundance and peace 🌊",
      "My mindset is transforming my reality beautifully 💫",
      "I trust myself to create an extraordinary future 🌸",
      "I no longer shrink myself for anyone 🌙",
      "I am becoming more disciplined and intentional 💖",
      "Success flows naturally into my life 🌿",
      "I attract people who support my growth ☀️",
      "Every challenge helps me evolve into someone stronger 🚀",
      "I am aligned with bigger opportunities ✨",
      "My future self is proud of the effort I’m making today 💫",
      "I choose growth even when it feels uncomfortable 🌸",
      "My confidence grows stronger with every step 🌙",
      "I am becoming mentally, emotionally, and financially stronger 💖",
      "I trust my ability to achieve great things 🌿",
      "I deserve recognition for my hard work ☀️",
      "I am glowing differently because I’m healing and growing ✨",
      "I attract experiences that upgrade my life 💫",
      "I am entering a season of powerful transformation 🌸",
      "My energy is magnetic and inspiring 🌙",
      "I no longer fear becoming successful 💖",
      "I am building habits that support my dream life 🌿",
      "Every small step I take is changing my future ☀️",
      "I trust the timing of my success completely 🚀",
      "My life is aligning more beautifully every day ✨",
      "I am becoming the person I once wished to be 💫",
      "I release self-doubt and choose confidence instead 🌸",
      "I deserve growth without burnout 🌙",
      "I attract abundance through consistency and focus 💖",
      "I believe deeply in my potential 🌿",
      "I am worthy of massive success and happiness ☀️",
      "My next level is already unfolding for me 🚀",
      "I trust myself to make bold and powerful decisions ✨",
      "I am becoming more focused on what truly matters 💫",
      "I release distractions and stay committed to my goals 🌸",
      "My life upgrades every time I choose myself 🌙",
      "I am evolving into someone unstoppable 💖",
      "I deserve to take up space and shine brightly 🌿",
      "I attract success by being authentic ☀️",
      "I trust my journey even when I cannot see everything ✨",
      "My growth inspires the people around me 💫",
    ],
    entriesHi: [],
  ),
  AffirmationCategory(
    name: "Healing Era",
    nameHi: "चिकित्सा काल",
    emoji: "🌸",
    entries: [
      "I am healing more every day 🌸",
      "My heart deserves gentle healing 🌙",
      "I allow myself to heal slowly and softly ☁️",
      "I release the pain I no longer need 💖",
      "I am becoming emotionally free 🌿",
      "Healing flows naturally through me ✨",
      "I deserve peace after everything I’ve been through 🌊",
      "My soul is learning to feel safe again 🌸",
      "I let myself rest without guilt 🌙",
      "I am healing in ways I cannot even see 💫",
      "I release old emotional wounds gently 💖",
      "My heart is becoming lighter every day 🌿",
      "I deserve softness and care ☁️",
      "I trust my healing journey completely ✨",
      "I no longer carry pain that belongs to the past 🌸",
      "My body and mind are healing together 🌊",
      "I allow myself to feel and release emotions 🌙",
      "Healing is safe for me now 💖",
      "I choose compassion toward myself 🌿",
      "I am learning to love myself again ✨",
      "Every breath brings me comfort 🌸",
      "I am not broken, I am healing 🌙",
      "My energy is becoming lighter and calmer ☁️",
      "I deserve emotional freedom 💖",
      "I trust that better days are coming 🌿",
      "I am healing from everything that hurt me ✨",
      "My nervous system feels calmer every day 🌊",
      "I let go of emotional heaviness gently 🌸",
      "I deserve to feel safe in my own body 🌙",
      "I welcome peace into my healing journey 💫",
      "I release what no longer serves my spirit 💖",
      "My healing does not need to be rushed 🌿",
      "I am becoming stronger through healing ☁️",
      "I forgive myself for the past ✨",
      "I deserve love while I heal 🌸",
      "My heart is slowly opening again 🌙",
      "I am healing from old versions of myself 💖",
      "I choose gentle thoughts about myself 🌿",
      "I trust myself to move forward slowly ✨",
      "My soul deserves rest and recovery 🌊",
      "I let go of sadness little by little 🌸",
      "Healing energy surrounds me constantly 🌙",
      "I deserve calmness after chaos ☁️",
      "I allow my emotions to flow safely 💖",
      "My healing is beautiful and valid 🌿",
      "I am learning to trust life again ✨",
      "I no longer need to carry emotional pain 🌊",
      "I choose healing over hiding 🌸",
      "My inner child deserves love and safety 🌙",
      "I am creating peace within myself 💫",
    ],
    entriesHi: [],
  ),
  AffirmationCategory(
    name: "Lucky Girl",
    nameHi: "लकी गर्ल",
    emoji: "🍀",
    entries: [
      "I am the luckiest girl wherever I go ✨",
      "Lucky opportunities find me naturally 🍀",
      "Everything works out beautifully for me 🌸",
      "I attract good news effortlessly 💫",
      "My life is filled with lucky moments 🌙",
      "I always end up in the right place at the right time ☁️",
      "The universe constantly surprises me positively 💖",
      "I attract blessings every single day 🌿",
      "Good things flow toward me easily 🌊",
      "I naturally attract fortunate outcomes ✨",
      "I am deeply supported by life 🍀",
      "Amazing opportunities appear out of nowhere 🌸",
      "My energy attracts miracles daily 💫",
      "I deserve a life filled with abundance 🌙",
      "I am always guided toward success ☁️",
      "People love helping and supporting me 💖",
      "I attract lucky coincidences constantly 🌿",
      "Everything aligns perfectly for me 🌊",
      "I am a magnet for positive experiences ✨",
      "My life keeps getting luckier and luckier 🍀",
      "I attract unexpected blessings 🌸",
      "I always receive exactly what I need 💫",
      "The universe favors me beautifully 🌙",
      "I am naturally lucky in all situations ☁️",
      "I deserve magical opportunities 💖",
      "My life unfolds in my favor 🌿",
      "I effortlessly attract abundance 🌊",
      "Lucky things happen around me constantly ✨",
      "I am aligned with success and fortune 🍀",
      "Everything works out better than expected 🌸",
      "I trust life to surprise me positively 💫",
      "I attract dream opportunities effortlessly 🌙",
      "My energy naturally draws good fortune ☁️",
      "I always receive positive outcomes 💖",
      "The universe is constantly blessing me 🌿",
      "I attract money and abundance naturally 🌊",
      "I am lucky in love, life, and success ✨",
      "My dreams are unfolding beautifully 🍀",
      "I deserve all the blessings coming to me 🌸",
      "I always find solutions easily 💫",
      "I attract happiness everywhere I go 🌙",
      "I naturally receive good news ☁️",
      "Everything in my life is aligning perfectly 💖",
      "I attract opportunities that change my life 🌿",
      "I am blessed beyond expectation 🌊",
      "I attract lucky people and situations ✨",
      "My future is filled with beautiful surprises 🍀",
      "The universe always has my back 🌸",
      "I effortlessly manifest my desires 💫",
      "My life feels magical lately 🌙",
    ],
    entriesHi: [],
  ),
  AffirmationCategory(
    name: "Deep Sleep",
    nameHi: "गहरी नींद",
    emoji: "🌙",
    entries: [
      "My body is ready for deep and peaceful sleep 🌙",
      "I release the stress of the day softly ☁️",
      "Sleep comes naturally and easily to me ✨",
      "My mind is becoming calm and quiet 🌊",
      "I deserve deep rest and recovery 💖",
      "Every breath relaxes my body more 🌸",
      "I feel safe, calm, and protected tonight 🌿",
      "My nervous system is slowing down gently 🌙",
      "I let go of all tension before sleep ☁️",
      "Rest flows through my entire body ✨",
      "I drift into sleep peacefully 🌊",
      "My thoughts are soft and quiet now 💖",
      "I allow my body to fully relax 🌸",
      "I deserve uninterrupted and healing sleep 🌙",
      "My room feels calm and comforting ☁️",
      "I release every anxious thought gently 🌿",
      "Sleep finds me effortlessly tonight ✨",
      "My body knows exactly how to rest 🌊",
      "I feel lighter with every breath 💖",
      "My mind is safe to slow down 🌸",
      "I let go of overthinking before sleep 🌙",
      "Peace fills my body completely ☁️",
      "I welcome deep relaxation tonight 🌿",
      "My muscles are relaxing gently ✨",
      "I am ready to rest deeply 🌊",
      "My heartbeat feels calm and steady 💖",
      "I deserve peaceful dreams 🌸",
      "My eyes feel heavy and relaxed 🌙",
      "I release emotional heaviness softly ☁️",
      "Sleep restores my energy beautifully ✨",
      "I feel calm, safe, and sleepy 🌊",
      "My body is healing while I rest 💖",
      "Every breath relaxes me more deeply 🌸",
      "I trust the night to hold me gently 🌙",
      "I release stress from my shoulders ☁️",
      "My thoughts are slowing down peacefully 🌿",
      "I deserve rest without guilt ✨",
      "My entire body feels relaxed 🌊",
      "I let the night calm my soul 💖",
      "I am sinking into deep rest 🌸",
      "Sleep comes easily to me tonight 🌙",
      "My body is grateful for this rest ☁️",
      "I release everything I cannot control 🌿",
      "I feel emotionally safe and calm ✨",
      "My breathing is slow and peaceful 🌊",
      "I deserve complete relaxation 💖",
      "My mind is becoming still 🌸",
      "The night feels soft and comforting 🌙",
      "I allow sleep to take over naturally ☁️",
      "Deep sleep is healing my body ✨",
    ],
    entriesHi: [],
  ),
  AffirmationCategory(
    name: "Morning Energy",
    nameHi: "सुबह की ऊर्जा",
    emoji: "🌅",
    entries: [
      "Today is a beautiful day full of opportunities 🌅",
      "I wake up feeling refreshed and deeply energized ☀️",
      "I choose to fill my morning with gratitude and light ✨",
      "Everything is aligning perfectly for me today 💛",
      "I step into this new day with total confidence 🌸",
      "My energy is vibrant and powerfully magnetic ⚡",
      "I am ready to conquer all of my goals today 🚀",
      "I attract beautiful miracles all morning long 💫",
      "I greet today with an open mind and heart 🌿",
      "My potential for today is absolutely limitless ☀️",
      "Good things are rushing toward me today 🌊",
      "I am deeply grateful for this brand new morning 🙏",
      "Success comes naturally to me throughout the day 💎",
      "I am the highest vibrating version of myself 🦋",
      "Today will bring me wonderful surprises 🎁",
      "I feel healthy, alive, and unstoppable 🌻",
      "My thoughts today will be powerful and positive 🌟",
      "I carry peace and joy with me everywhere I go 🕊️",
      "Everything I do today leads to massive success 🍀",
      "I am glowing from the inside out 💖",
    ],
    entriesHi: [],
  ),
];

// ════════════════════════════════════════════════════════════════════
//  AUDIO TRACKS — Healing Frequencies
// ════════════════════════════════════════════════════════════════════

class AudioTrack {
  final String name;
  final String nameHi;
  final String frequency;
  final String path; // assets/audio/xxx.wav
  final Duration duration;
  final String? description;
  final String? descriptionHi;

  AudioTrack({
    required this.name,
    required this.nameHi,
    required this.frequency,
    required this.path,
    required this.duration,
    this.description,
    this.descriptionHi,
  });
}

final kHealingFrequencies = [
  AudioTrack(
    name: "432Hz Deep Healing",
    nameHi: "432Hz गहरी उपचार",
    frequency: "432Hz",
    path: "assets/audio/432hz_healing.wav",
    duration: Duration(minutes: 45),
    description: "Heart chakra resonance - deep healing vibrations",
    descriptionHi: "हृदय चक्र अनुनाद - गहरी उपचार कंपन",
  ),
  AudioTrack(
    name: "396Hz Fear Clearing",
    nameHi: "396Hz भय साफ",
    frequency: "396Hz",
    path: "assets/audio/396hz_fear.wav",
    duration: Duration(minutes: 30),
    description: "Root chakra liberation from fear",
    descriptionHi: "मूल चक्र भय से मुक्ति",
  ),
  AudioTrack(
    name: "528Hz Transformation",
    nameHi: "528Hz रूपांतर",
    frequency: "528Hz",
    path: "assets/audio/528hz_miracle.wav",
    duration: Duration(hours: 1),
    description: "DNA activation and renewal",
    descriptionHi: "डीएनए सक्रियण और नवीकरण",
  ),
  AudioTrack(
    name: "639Hz Connection",
    nameHi: "639Hz जुड़ाव",
    frequency: "639Hz",
    path: "assets/audio/639hz_connection.wav",
    duration: Duration(hours: 1, minutes: 15),
    description: "Heart-centered relationships and love",
    descriptionHi: "हृदय-केंद्रित रिश्ते और प्रेम",
  ),
  AudioTrack(
    name: "741Hz Expression",
    nameHi: "741Hz अभिव्यक्ति",
    frequency: "741Hz",
    path: "assets/audio/741hz_throat.wav",
    duration: Duration(minutes: 45),
    description: "Throat chakra - authentic expression",
    descriptionHi: "गला चक्र - सत्य अभिव्यक्ति",
  ),
  AudioTrack(
    name: "852Hz Intuition",
    nameHi: "852Hz अंतर्ज्ञान",
    frequency: "852Hz",
    path: "assets/audio/852hz_intuition.wav",
    duration: Duration(minutes: 30),
    description: "Third eye opening - heightened intuition",
    descriptionHi: "तीसरी आँख खुलना - बढ़ी अंतर्ज्ञान",
  ),
  AudioTrack(
    name: "963Hz Transcendence",
    nameHi: "963Hz श्रेष्ठता",
    frequency: "963Hz",
    path: "assets/audio/963hz_crown.wav",
    duration: Duration(minutes: 60),
    description: "Crown chakra - highest consciousness",
    descriptionHi: "मुकुट चक्र - सर्वोच्च चेतना",
  ),
  AudioTrack(
    name: "174Hz Deep Sleep",
    nameHi: "174Hz गहरी नींद",
    frequency: "174Hz",
    path: "assets/audio/174hz_sleep.wav",
    duration: Duration(hours: 2),
    description: "Delta waves - profound sleep and rest",
    descriptionHi: "डेल्टा तरंगें - गहरी नींद",
  ),
];
// ════════════════════════════════════════════════════════════════════
//  COMPATIBILITY TYPES & MAPS  (consumed by main.dart)
// ════════════════════════════════════════════════════════════════════

/// AffEntry — a single affirmation item with text, emoji, and optional Hindi translation.
/// Used by main.dart for category detail lists and todaysAffirmation.
class AffEntry {
  final String text;
  final String emoji;
  final String? textHi;
  const AffEntry(this.text, this.emoji, [this.textHi]);
}

/// AffCategory — alias for AffirmationCategory.
typedef AffCategory = AffirmationCategory;

/// Total affirmation count across all categories.
int get kTotalAffirmations =>
    kAffCategories.fold(0, (sum, c) => sum + c.count);

/// Look up a category by snake_case id (e.g. 'inner_peace').
AffirmationCategory? getCategory(String id) =>
    kAffCategories.cast<AffirmationCategory?>().firstWhere(
      (c) => c!.name.toLowerCase().replaceAll(' ', '_') == id,
      orElse: () => kAffCategories.isNotEmpty ? kAffCategories.first : null,
    );

/// Mood index (0=Low Vibe … 4=Glowing) → category id.
const kMoodCategoryMap = <int, String>{
  0: 'inner_peace',
  1: 'healing_era',
  2: 'self_love',
  3: 'level_up',
  4: 'abundance',
};

/// Mood index → recommended soundscape name.
const kMoodSoundMap = <int, String>{
  0: 'Inner Peace Rain',
  1: 'Chakra Balancing',
  2: 'Self Love Morning',
  3: 'Morning Abundance',
  4: '432Hz Deep Healing',
};

/// Mood index → healing frequency label.
const kMoodFreqMap = <int, String>{
  0: '396Hz — Fear Clearing',
  1: '417Hz — Change',
  2: '528Hz — DNA Repair',
  3: '639Hz — Connection',
  4: '741Hz — Expression',
};

/// Mood index → journal prompt (English).
const kMoodJournalPrompt = <int, String>{
  0: 'What one gentle thing can I do for myself right now?',
  1: 'What am I releasing with love today?',
  2: 'What is something beautiful about me I sometimes forget?',
  3: 'What dream am I calling in with full confidence?',
  4: 'What miracle am I ready to receive today?',
};

/// Mood index → journal prompt (Hindi).
const kMoodJournalPromptHi = <int, String>{
  0: 'अभी मैं अपने लिए एक कोमल काम क्या कर सकती हूं?',
  1: 'आज मैं प्यार के साथ क्या छोड़ रही हूं?',
  2: 'मेरे बारे में एक खूबसूरत बात?',
  3: 'एक सपना जिसे मैं पूरे विश्वास से बुला रही हूं?',
  4: 'आज मैं कौन सा चमत्कार पाने को तैयार हूं?',
};
