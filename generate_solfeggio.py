import wave
import struct
import math
import os

sample_rate = 44100.0
duration = 15.0 # seconds

frequencies = {
    '174hz_sleep.wav': 174.0,
    '396hz_fear.wav': 396.0,
    '432hz_healing.wav': 432.0,
    '528hz_miracle.wav': 528.0,
    '639hz_connection.wav': 639.0,
    '741hz_throat.wav': 741.0,
    '852hz_intuition.wav': 852.0,
    '963hz_crown.wav': 963.0
}

os.makedirs('assets/audio', exist_ok=True)

for fname, freq in frequencies.items():
    wavef = wave.open('assets/audio/' + fname, 'w')
    wavef.setnchannels(1) # mono
    wavef.setsampwidth(2) 
    wavef.setframerate(sample_rate)

    for i in range(int(duration * sample_rate)):
        # Generate pure sine wave
        value = int(32767.0 * math.sin(freq * math.pi * 2.0 * i / sample_rate))
        # Add smooth fade in and fade out
        if i < sample_rate: # 1 second fade in
            value = int(value * (i / sample_rate))
        elif i > (duration * sample_rate) - sample_rate: # 1 second fade out
            value = int(value * (((duration * sample_rate) - i) / sample_rate))
            
        data = struct.pack('<h', value)
        wavef.writeframesraw(data)
        
    wavef.close()
    print(f"Generated {fname}")
