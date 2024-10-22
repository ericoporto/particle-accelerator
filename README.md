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

#### `Emitter.ParticlesHitPoint`
```AGS Script
Particle * [] Emitter.ParticlesHitPoint(int x, int y);
```

Get null terminated array of particles that overlaps with the given point.

#### `Emitter.ParticlesHitRect`
```AGS Script
Particle * [] Emitter.ParticlesHitRect(int x, int y, int width, int height);
```

Get null terminated array of particles that overlaps with the given rectangle.


### Particle

This struct represents a single particle in the particle system. It is used to simulate the movement, appearance, and behavior of each particle.

It's managed by the emitter and they can be retrieved through specific methods in the emitter (for now only hit tests), and then you can get some information from each directly.

#### `Particle.Life`
```AGS Script
int attribute Particle.Life;
```
The remaining life of the particle. It decrements on each update and the particle dies when its life is equal to or below zero.

#### `Particle.IsAlive`
```AGS Script
bool Particle.IsAlive();
```
Returns `true` if the particle is still alive (i.e., its life is greater than zero), and `false` otherwise.

#### `Particle.HitsPoint`
```AGS Script
bool Particle.HitsPoint(int x, int y);
```
Returns `true` if the particle overlaps the given point (x, y). The particle is assumed to be a rectangle for the purpose of hit detection.

#### `Particle.HitsRect`
```AGS Script
bool Particle.HitsRect(int x, int y, int width, int height);
```
Returns `true` if the particle overlaps the given rectangle (x, y, width, height). The particle is assumed to be a rectangle for the purpose of hit detection.


### ParticleDefinition

This struct defines the behavior and visual properties of particles. It is used by the emitter to generate new particles with specific characteristics.

When you set the value of them, it's usually a good idea to create a function to encapsulate this setting, so you can produce many different values with random settings on each definition.

#### `ParticleDefinition.Sprite`
```AGS Script
int ParticleDefinition.Sprite;
```
The sprite used for the particle. If `SpriteBegin` and `SpriteEnd` are set, this defines the initial frame of the particle animation.

#### `ParticleDefinition.OffsetX`
```AGS Script
int ParticleDefinition.OffsetX;
```
The horizontal offset from the emitter's position when the particle is emitted.

#### `ParticleDefinition.OffsetY`
```AGS Script
int ParticleDefinition.OffsetY;
```
The vertical offset from the emitter's position when the particle is emitted.

#### `ParticleDefinition.LifeTotal`
```AGS Script
int ParticleDefinition.LifeTotal;
```
The total lifetime of the particle, in update loops. This value is used to initialize the particle's life when it is emitted.

#### `ParticleDefinition.VelX`
```AGS Script
int ParticleDefinition.VelX;
```
The initial horizontal velocity of the particle, in thousandths of a pixel per update loop.

#### `ParticleDefinition.VelY`
```AGS Script
int ParticleDefinition.VelY;
```
The initial vertical velocity of the particle, in thousandths of a pixel per update loop.

#### `ParticleDefinition.Gravity`
```AGS Script
int ParticleDefinition.Gravity;
```
The vertical acceleration applied to the particle over time (gravity), in thousandths of a pixel per update loop.

#### `ParticleDefinition.SpriteBegin`
```AGS Script
int ParticleDefinition.SpriteBegin;
```
The initial sprite frame of a sequential sprite range.

#### `ParticleDefinition.SpriteEnd`
```AGS Script
int ParticleDefinition.SpriteEnd;
```
The final sprite frame of a sequential sprite range.

#### `ParticleDefinition.TransparencyBegin`
```AGS Script
int ParticleDefinition.TransparencyBegin;
```
The transparency level when the particle is emitted. A value of 0 is fully opaque, and 100 is fully transparent.

#### `ParticleDefinition.TransparencyEnd`
```AGS Script
int ParticleDefinition.TransparencyEnd;
```
The transparency level when the particle reaches the end of its life.

#### `ParticleDefinition.WidthBegin`
```AGS Script
int ParticleDefinition.WidthBegin;
```
The width of the particle when it is emitted.

#### `ParticleDefinition.WidthEnd`
```AGS Script
int ParticleDefinition.WidthEnd;
```
The width of the particle when it reaches the end of its life.

#### `ParticleDefinition.HeightBegin`
```AGS Script
int ParticleDefinition.HeightBegin;
```
The height of the particle when it is emitted.

#### `ParticleDefinition.HeightEnd`
```AGS Script
int ParticleDefinition.HeightEnd;
```
The height of the particle when it reaches the end of its life.

#### `ParticleDefinition.Bounces`
```AGS Script
bool ParticleDefinition.Bounces;
```
Determines whether the particle should bounce when it hits the ground.

#### `ParticleDefinition.GroundY`
```AGS Script
int ParticleDefinition.GroundY;
```
The vertical position that the particle will treat as the ground for bounce detection. If this is not set, the particle will not recognize any ground.

#### `ParticleDefinition.BlendMode`
```AGS Script
BlendMode ParticleDefinition.BlendMode;
```
The blend mode to use when rendering the particle.

**Compatibility:** This is only available in AGS 4.0 and above.

#### `ParticleDefinition.Angle`
```AGS Script
float ParticleDefinition.Angle;
```
The initial rotation angle of the particle, in degrees (0 to 360).

**Compatibility:** This is only available in AGS 4.0 and above.

#### `ParticleDefinition.RotationSpeed`
```AGS Script
float ParticleDefinition.RotationSpeed;
```
The speed at which the particle rotates, in degrees per update loop.

**Compatibility:** This is only available in AGS 4.0 and above.
