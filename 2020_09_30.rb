# first day of sonic pi, got through the first 6 sections of tutorials
# first substantial melody in sonic pi
# finished Tue 29 Sep 2020 11:57:43 PM PDT

sleep_time = 2 * (sample_duration :loop_amen)
# cycle through related chords/notes
noise_chords = [:e, :e, :g, :a]
noise_cycle = [4, 4, 4, 6]
chord_idx = 0
note_idx = 0

inital_seed = 19283918391
use_random_seed inital_seed

define :chord_player do |root, repeats|
  repeats.times do
    with_fx :ixi_techno do
      # this play is commented out at the end of the track
      play chord(root, :minor), release: 0.4, attack: 0.001, amp: 0.5
      sleep (sleep_time / 16)
    end
  end
end

define :background_chord do
  chosen_chord = noise_chords[chord_idx % noise_chords.length]
  chord_idx += 1
  use_synth :saw
  with_fx :flanger do
    play chord(chosen_chord, :minor), amp: 0.1, attack: 0.2, sustain: 1, release: 2
  end
end

define :melody do
  ##| increment current location in 'melody'
  chosen_chord = noise_chords[chord_idx % noise_chords.length]
  chosen_cycle = noise_cycle[note_idx % noise_cycle.length]
  note_idx += 1

  # little melody for each time we go around
  # toggle panslice at the end of the melody
  # for most of the track this is true, which makes it echo-y
  # turned off at the end
  panslice = true
  chosen_cycle.times do
    use_synth :sine
    if panslice
      with_fx :panslicer, pan_max: 0.4 do
        play chord(chosen_chord, :minor7).pick, amp: 0.2
      end
    else
      play chord(chosen_chord, :minor7).pick, amp: 0.4
    end
    sleep (sleep_time / 16)
  end
end

# good ol loop amen
live_loop :drums do
  # toggled manually
  if true
    sample :loop_amen, rate: 0.5, amp: 0.4
    sleep sleep_time
  else
    sleep sleep_time
  end
end

live_loop :synths do
  use_synth :tri
  # drone-y background chord
  in_thread do
    background_chord
  end
  chord_player :e3, 2
  sleep (sleep_time / 8)
  sleep (sleep_time / 16)
  chord_player :a3, 1
  sleep (sleep_time / 16)
  chord_player :a3, 1
  sleep (sleep_time / 16)
  chord_player :a3, 1
  # do this in a thread so it doesn't affect the other timing for the synths
  in_thread do
    melody
  end
  chord_player :g3, 2
  chord_player :e3, 2
  sleep (sleep_time / 8)
end
