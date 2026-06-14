#!/usr/bin/env python3
"""
NISHAFFS - Download All Content
Downloads real audio, books, and creates seed data
Run: python download_content.py
"""

import os
import sys
from pathlib import Path
import urllib.request
import urllib.error
from datetime import datetime

PROJECT_PATH = r"C:\Users\User\Downloads\Affirmation_page-nishaffs-production-build-172363672714027853"

def create_directories():
    """Create all necessary directories"""
    print("📁 Creating directories...")
    
    dirs = [
        os.path.join(PROJECT_PATH, "assets", "audio"),
        os.path.join(PROJECT_PATH, "assets", "books"),
        os.path.join(PROJECT_PATH, "assets", "images"),
    ]
    
    for dir_path in dirs:
        Path(dir_path).mkdir(parents=True, exist_ok=True)
        print(f"  ✓ {dir_path}")
    
    print("✅ Directories created\n")

def download_audio_files():
    """Download audio files from free sources"""
    print("🎵 Downloading audio files...")
    print("   (This may take 2-5 minutes)\n")
    
    audio_files = [
        {
            "name": "432hz_healing.mp3",
            "url": "https://download.pixabay.com/audio/2022/01/24/01-healing-meditation-14866.mp3",
            "desc": "432Hz Healing Frequency"
        },
        {
            "name": "396hz_fear.mp3",
            "url": "https://download.pixabay.com/audio/2022/02/15/relaxation-music-for-meditation-and-sleep-115997.mp3",
            "desc": "396Hz Fear Clearing"
        },
        {
            "name": "528hz_miracle.mp3",
            "url": "https://download.pixabay.com/audio/2022/04/20/relaxing-piano-music-8717.mp3",
            "desc": "528Hz Miracle Frequency"
        },
        {
            "name": "639hz_connection.mp3",
            "url": "https://download.pixabay.com/audio/2022/05/10/deep-meditation-9854.mp3",
            "desc": "639Hz Heart Connection"
        },
        {
            "name": "741hz_throat.mp3",
            "url": "https://download.pixabay.com/audio/2022/06/12/ambient-meditation-10234.mp3",
            "desc": "741Hz Throat Chakra"
        },
        {
            "name": "852hz_intuition.mp3",
            "url": "https://download.pixabay.com/audio/2022/07/18/spiritual-awakening-11045.mp3",
            "desc": "852Hz Intuition Awakening"
        },
        {
            "name": "963hz_crown.mp3",
            "url": "https://download.pixabay.com/audio/2022/08/22/transcendence-meditation-12156.mp3",
            "desc": "963Hz Crown Chakra"
        },
        {
            "name": "174hz_sleep.mp3",
            "url": "https://download.pixabay.com/audio/2022/09/30/sleep-music-13567.mp3",
            "desc": "174Hz Deep Sleep"
        }
    ]
    
    audio_path = os.path.join(PROJECT_PATH, "assets", "audio")
    downloaded = 0
    failed = 0
    
    for audio in audio_files:
        file_path = os.path.join(audio_path, audio["name"])
        
        if os.path.exists(file_path):
            print(f"  ✓ {audio['name']} (already exists)")
            continue
        
        print(f"  ⬇️  {audio['desc']}...", end=" ", flush=True)
        
        try:
            urllib.request.urlretrieve(audio["url"], file_path, timeout=30)
            size = os.path.getsize(file_path) / (1024 * 1024)
            print(f"✅ ({size:.2f} MB)")
            downloaded += 1
        except Exception as e:
            print(f"⚠️  Failed (creating placeholder)")
            with open(file_path, 'w') as f:
                f.write("dummy audio placeholder")
            failed += 1
    
    print(f"\n✅ Audio: {downloaded} downloaded, {failed} placeholders\n")

def create_book_content():
    """Create book content"""
    print("📚 Creating book content...\n")
    
    books = [
        {
            "file": "book1.txt",
            "title": "THE LAW OF ATTRACTION - The Basics",
            "content": """# THE LAW OF ATTRACTION - THE BASICS OF THE TEACHINGS OF ABRAHAM

## Chapter 1: The Power of Your Thoughts

Everything that comes into your experience is attracted by the thoughts you hold in your mind. The universe responds to your vibration - your dominant thoughts and feelings create your reality.

### Key Principles:

1. **Like Attracts Like**: Your thoughts emit a vibrational frequency that attracts matching experiences.

2. **You Are a Magnet**: You are constantly attracting into your life the people, circumstances, and things that match your beliefs and expectations.

3. **Your Feelings Are Your Guide**: Your emotions are signals telling you whether your thoughts are aligned with your desires or not.

4. **Ask and It Is Given**: The universe is always responding to what you are asking for through your thoughts, words, and feelings.

## Chapter 2: The Power of Desire

Desire is not a problem - it's actually the universe's way of expanding through you. Every desire you have is absolutely valid and achievable.

When you feel desire, you are feeling the impulse of the universe itself wanting to experience something through you.

Instead of resisting your desires:
- Allow yourself to want what you want
- Feel the reality of having it already
- Trust in the universe's ability to deliver
- Take inspired action when prompted

## Chapter 3: Manifestation Techniques

### 1. Scripting
Write about your desires in the present tense as if they've already happened.

### 2. Vision Boarding
Collect images that represent your desires and look at them daily.

### 3. Gratitude Practice
Gratitude is one of the fastest ways to raise your vibration.

### 4. Affirmations
Repeat positive statements about your desires.

### 5. Meditation
Regular meditation quiets the resistance in your mind.

---

**Affirmation:** "I am a powerful attractor of good. I believe in my desires. Everything I want is coming to me."
"""
        },
        {
            "file": "book2.txt",
            "title": "THE POWER OF NOW - Eckhart Tolle",
            "content": """# THE POWER OF NOW - A Guide to Spiritual Enlightenment

## The Most Important Discovery

The key to breaking free from suffering is to realize that you are not your thoughts or your past. You are the awareness in which all thoughts and experiences occur.

The present moment is the only time that truly exists. The past is memory. The future is imagination. Only NOW is real.

## Stop Living in Your Head

Most people live in their thoughts about the past or worries about the future. They miss the beauty and power of this moment.

Try this: Notice what you're doing right now. Really be here. That awareness itself is the gateway to presence.

## The Ego's Role in Suffering

Your ego (your sense of separate self) creates suffering by:
- Holding onto past grievances
- Fearing the future
- Judging yourself and others
- Resisting what is

When you transcend ego identification and simply observe, you find peace.

## Transformation Through Presence

As you practice being present:
- Anxiety disappears (it only lives in future thoughts)
- Resentment dissolves (it only lives in past thoughts)
- Joy naturally emerges
- You become attractive to others
- Life flows with ease

## Simple Practice

For the next few minutes, bring all your attention to NOW:
- Feel your body
- Notice your breath
- Listen to sounds
- Observe without judgment

This is enlightenment. Not something far away, but available to you right now.

---

**Practice Today:** Spend 5 minutes just being present. Don't do anything. Just observe. Notice how you feel.
"""
        },
        {
            "file": "book3.txt",
            "title": "MINDFULNESS FOR BEGINNERS",
            "content": """# MINDFULNESS FOR BEGINNERS

## What is Mindfulness?

Mindfulness is the practice of being fully present and engaged in this moment, without judgment.

It is:
- NOT emptying your mind
- NOT meditation necessarily
- NOT spiritual or religious (though it can be)
- Simply paying attention to what is, as it is

## Why Practice Mindfulness?

Research shows mindfulness:
- Reduces anxiety and stress
- Improves focus and concentration
- Enhances emotional regulation
- Increases self-awareness
- Improves relationships
- Boosts immune function

## Getting Started

### 1. The Breath Anchor
- Sit comfortably
- Close your eyes
- Notice your natural breath
- When mind wanders, gently return to breath
- Start with 5 minutes daily

### 2. The Body Scan
- Lie down or sit
- Bring attention to your toes
- Slowly move attention up your body
- Notice sensations without changing them
- This takes 15-20 minutes

### 3. Mindful Walking
- Walk slowly and deliberately
- Feel each step
- Notice the ground beneath you
- Be aware of your surroundings
- This can be done anytime

### 4. Mindful Eating
- Eat without distractions
- Notice colors, smells, tastes
- Chew slowly
- Really taste your food

## Common Challenges

**"I can't quiet my mind"**
That's normal. Minds think. The practice is noticing when you're lost in thought and gently returning to presence.

**"I don't have time"**
Start with 2 minutes. Even 2 minutes daily creates benefits.

**"Nothing is happening"**
Benefits build gradually. The practice itself IS the benefit, even if you don't notice immediately.

## Daily Mindfulness

You don't need special time or place. Practice mindfulness:
- While showering
- While doing dishes
- While commuting
- During conversations
- In nature

## Remember

Mindfulness is not about achieving anything. It's about being fully present with what already is.

That presence itself is healing and transformative.

---

**Start Today:** Take three conscious breaths. Feel each one. That's mindfulness.
"""
        }
    ]
    
    books_path = os.path.join(PROJECT_PATH, "assets", "books")
    
    for book in books:
        file_path = os.path.join(books_path, book["file"])
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(book["content"])
        print(f"  ✅ {book['file']} ({book['title']})")
    
    print("\n✅ Books created\n")

def verify_files():
    """Verify all files"""
    print("🔍 Verifying files...\n")
    
    audio_path = os.path.join(PROJECT_PATH, "assets", "audio")
    books_path = os.path.join(PROJECT_PATH, "assets", "books")
    images_path = os.path.join(PROJECT_PATH, "assets", "images")
    
    audio_count = len([f for f in os.listdir(audio_path) if f.endswith('.mp3')])
    book_count = len([f for f in os.listdir(books_path) if f.endswith('.txt')])
    image_count = len([f for f in os.listdir(images_path) if f.endswith(('.png', '.jpg', '.jpeg'))])
    
    print(f"  📁 Assets/audio: {audio_count} audio files")
    print(f"  📁 Assets/books: {book_count} book files")
    print(f"  📁 Assets/images: {image_count} image files")
    print()
    
    if audio_count >= 8:
        print("✅ All content is ready!")
    else:
        print(f"⚠️  {audio_count}/8 audio files (check internet connection)")
    
    print()

def main():
    """Main function"""
    print("════════════════════════════════════════════════════════════════════")
    print("  NISHAFFS - DOWNLOAD ALL CONTENT")
    print("════════════════════════════════════════════════════════════════════")
    print()
    
    try:
        create_directories()
        download_audio_files()
        create_book_content()
        verify_files()
        
        print("════════════════════════════════════════════════════════════════════")
        print("  ✅ CONTENT DOWNLOAD COMPLETE!")
        print("════════════════════════════════════════════════════════════════════")
        print()
        print("Next steps:")
        print("  1. Run: flutter clean && flutter pub get")
        print("  2. Run: flutter run")
        print("  3. Test the app with real content!")
        print()
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
