# particle-accelerator
Particle Script Module for AGS

## Usage

Here is a simple example

```AGS Script

// encapsulate definition in a function to be able to apply randomnes
ParticleDefinition* GetSparkleParticle()
{
  ParticleDefinition* sparkleParticle = new ParticleDefinition;
  sparkleParticle.LifeTotal = 50;
  sparkleParticle.VelX = Random(3000) - 1000;
  sparkleParticle.VelY = Random(3000) - 1000;
  sparkleParticle.TransparencyBegin = 0;
  sparkleParticle.TransparencyEnd = 100;
  sparkleParticle.WidthBegin = 3;
  sparkleParticle.WidthEnd = 8;
  sparkleParticle.HeightBegin = 3;
  sparkleParticle.HeightEnd = 8;
  sparkleParticle.Gravity = 100;
  sparkleParticle.GroundY = 154;
  sparkleParticle.Bounces = true;
  return sparkleParticle;
}

Emitter emt;

void room_AfterFadeIn()
{
  // Create array of particle definitions
  int defs_count = 2048;
  ParticleDefinition *defs[] = new ParticleDefinition[defs_count];
  for(i=0; i<defs_count; i++)
  {
    defs[i] = GetSparkleParticle();
  }
  
  // Emitter at (150, 90) emitting 10 particles, max 256 at a time
  emt.Init(150, 90, defs, defs_count, 10,  256);
}

void on_mouse_click(MouseButton button)
{
  // Emit particles on click
  emt.SetPosition(mouse.x, mouse.y);
  emt.Emit();
}

function repeatedly_execute_always()
{
  emt.Update();
}
```

## Script API

### Emitter

This struct is the main way we will manage particles in this module.

#### `Emitter.Init`
```AGS Script
void Emitter.Init(int x, int y, ParticleDefinition * defs[], int defCount, int emitAmount, int maxParticles);
```

Initializes the emitter, has to be run once, before invoking any other method from the emitter.

You will pass the following parameters

- a position (x, y) to place the emitter (it can be set later to other using SetPosition method)
- an array of Particle Definitions, along with the size of this array
- the amount of particles that should be emitted when calling Emit()
- the maximum number of particles that should exist at the same time

#### `Emitter.Update`
```AGS Script
void Emitter.Update();
```

This method will both run one step in the particle simulation and update their rendering on the screen using overlays.

You normally run this once in repeatedly_execute_always, room_RepExec or some other method you use to run once per frame.

#### `Emitter.Emit`
```AGS Script
bool Emitter.Emit();
```

Emits particles. The amount of particles emitted is the emitAmount set when you init the emitter.

A random particle definition is selected from the set definitions arrays, and used to initialize each particle emitted individually.

#### `Emitter.SetPosition`
```AGS Script
void Emitter.SetPosition(int x, int y);
```

Sets the position of the emitter on screen.

#### `Emitter.SetDefinitions`
```AGS Script
void Emitter.SetDefinitions(ParticleDefinition * defs[], int defCount);
```

Sets the definitions hold by the emitter.

### Particle

TBD.

### ParticleDefinition

TBD

