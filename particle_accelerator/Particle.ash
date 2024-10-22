// Particle Accelerator module header
// Module to manage particle effects based on Overlays
//
//    +-------------------------+
//    |        Emitter          |
//    |-------------------------|       +--------------------+
//    |  Array of Definitions   |<------| ParticleDefinition |
//    |  Pool of Particles      |       +--------------------+
//    +-------------------------+        (sprite, velocity, size, etc.)
//                |
//                |    Emits based on a random
//                |   selection from definitions
//                v
//     +--------------------+
//     |      Particle      |
//     +--------------------+
// 
// - Emitter: how we will manage particles in this module.
// - ParticleDefinition: a description of particle behavior and visuals;
// - Particle: a logical simulation unit, it's kept in sync with an overlay for rendering;
//
// Emitter main actions
// 1. Init: used to configure the emitter, must be done before anything else
// 2. Emit: randomly select a ParticleDefinition and spawn a Particle with its properties;
// 3. Update: run each particle logic and update its corresponding overlay, until its life ends;
//

managed struct ParticleDefinition {
  /// The particle sprite. If SpriteBegin/End are set, it's the initial frame. 
  int Sprite;
  /// Horizontal Offset from the emitter position
  int OffsetX;
  /// Vertical Offset from the emitter position
  int OffsetY;
  /// The initial life of the particle, it's Lifetime in update loops
  int LifeTotal;
  /// Horizontal milli velocity. It's in thousandths of a pixel per update, in X direction (e.g., 1000 moves 1 pixel to right per update).
  int VelX; 
  /// Vertical milli velocity. It's in thousandths of a pixel per update, in Y direction (e.g., -2000 moves 2 pixels upwards per update).
  int VelY;
  /// Milli Gravity (vertical acceleration).
  int Gravity;
  /// The initial sprite of a sequential Sprite range (see Sprite for initial frame).
  int SpriteBegin;
  /// The final sprite of a sequential Sprite range.
  int SpriteEnd;
  /// Initial transparency, the transparency when emitted.
  int TransparencyBegin;
  /// Final transparency, the transparency when the particle's life is zero.
  int TransparencyEnd;
  /// Initial width, the width when emitted.
  int WidthBegin;
  /// Final width, the width when the particle's life is zero.
  int WidthEnd;
  /// Initial height, the height when emitted.
  int HeightBegin;
  /// Final height, the height when the particle's life is zero.
  int HeightEnd;
  /// If the particle should bounce when it hits ground
  bool Bounces;
  /// The ground level position for the particle (if unset, assumes no ground exists)
  int GroundY;
  #ifdef SCRIPT_API_v400
  /// The blend mode the particle should use
  BlendMode BlendMode;
  /// The angle in degrees (0.0 to 360.0) the particle should be
  float Angle;
  /// The speed that will increase the angle in degrees per update loop
  float RotationSpeed;
  #endif
};

managed struct Particle {
  /// The particle life, it decrements on each update. It dies when life is equal or below zero.
  import attribute int Life;
  /// returns true if particle is alive
  import bool IsAlive();
  /// returns true if the particle overlaps the given point. The particle is assumed to be a rectangle.
  import bool HitsPoint(int x, int y);
  /// returns true if the particle overlaps the given rectangle. The particle is assumed to be a rectangle.
  import bool HitsRect(int x, int y, int width, int height);

  // private internals
  protected int X;
  protected int Y;
  protected int MilliX; // milli x (~1000 times x)
  protected int MilliY; // milli y (~1000 times y)
  protected int Sprite;
  protected int InitialLife;
  protected int VelX; // x velocity
  protected int VelY; // y velocity
  protected int Gravity; // this is vertical acceleration downwards
  protected int Transparency;
  protected int Width;
  protected int Height;
  protected int SpriteBegin;
  protected int SpriteCycleOffset;
  protected int SpriteDelta;
  protected int TransparencyBegin;
  protected int TransparencyDelta;
  protected int WidthBegin;
  protected int WidthDelta;
  protected int HeightBegin;
  protected int HeightDelta;
  protected bool Bounces;
  protected int GroundY;
  #ifdef SCRIPT_API_v400
  protected float RotationSpeed;
  protected float Angle;
  #endif
  // not actual public interface and should not be used or relied upon
  int _Life; // $AUTOCOMPLETEIGNORE$
  int _OverlayIdx; // $AUTOCOMPLETEIGNORE$
};

struct Emitter {
  /// Initialize the emitter
  import void Init(int x, int y, ParticleDefinition * defs[], int defCount, int emitAmount, int maxParticles);
  /// Emit particles set in emitBurst, returns true if succeed emitting all particles
  import bool Emit();
  /// Update all particles
  import void Update();
  /// Set emitter possible particle definitions
  import void SetParticleDefinitions(ParticleDefinition * definitions[], int definitionsCount);
  /// Update emitter position
  import void SetPosition(int x, int y);
  /// Get null terminated array of particles that overlaps with the given point.
  import Particle * [] ParticlesHitPoint(int x, int y);
  /// Get null terminated array of particles that overlaps with the given rectangle.
  import Particle * [] ParticlesHitRect(int x, int y, int width, int height);

  // private internals
  protected int X;
  protected int Y;
  protected int EmitAmount;
  protected int maxParticles;
  protected String uID;
  protected Particle * particles[]; // Pool of particles
  protected ParticleDefinition * definitions[]; // Array of particle definitions
  protected int definitionsCount; // Count of particle definitions
  protected int lastEmittedParticle;
  import protected bool _EmitParticleIndex(int i);
  import protected bool _EmitSingleParticle();
  import protected bool _HandleRoomChanged();
  import protected ParticleDefinition* _GetRandomDefinition();
};

struct ContinuousEmitter extends Emitter {
  protected int emitInterval;
  protected int _emitCooldown;
  protected bool isEmitting;

  /// Starts the emission of particles at regular intervals. Interval unit is in update loops.
  import void StartEmitting(int emitInterval = 11);
  /// Stops the emission of particles.
  import void StopEmitting();
  import void UpdateContinuous();
};

/// Global Particle Emitter
import ContinuousEmitter GPE;