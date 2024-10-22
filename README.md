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
