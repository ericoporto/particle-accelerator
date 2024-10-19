// new module header

managed struct ParticleDefinition {
  /// The particle sprite. If SpriteBegin/End are set, it's the initial frame. 
  int Sprite;
  /// Horizontal Offset from the emitter position
  int OffsetX;
  /// Vertical Offset from the emitter position
  int OffsetY;
  /// The initial life of the particle, it's Lifetime in loops
  int life;
  /// Mili Velocity in X direction (horizontal).
  int VelX; 
  /// Mili Velocity in Y direction (vertical).
  int VelY;
  /// Mili Gravity (vertical acceleration).
  int Gravity;
  /// The initial sprite of a sequential Sprite range (see Sprite for initial frame).
  int SpriteBegin;
  /// The final sprite of a sequential Sprite range.
  int SpriteEnd;
  /// Initial transparency, the Transparency when emitted.
  int TransparencyBegin;
  /// Final transparency, the Transparency when Particle life is zero.
  int TransparencyEnd;
  /// Initial width, the Width when emitted.
  int WidthBegin;
  /// Final width, the Width when Particle life is zero.
  int WidthEnd;
  /// Initial height, the Height when emitted.
  int HeightBegin;
  /// Final height, the Height when Particle life is zero.
  int HeightEnd;
  /// If the particle should bounce when it hits ground
  bool Bounces;
  /// The ground level position for the particle (if unset assumes no ground exists)
  int GroundY;
  #ifdef SCRIPT_API_v400
  /// The blend mode the particle should use
  BlendMode BlendMode;
  /// The angle in degrees (0.0 to 360.0) the particle should be
  float Angle;
  /// The speed that will increase the angle per loop
  float RotationSpeed;
  #endif
};

managed struct Particle {
  int Sprite;
  int X;
  int Y;
  protected int mx; // mili x (~1000 times x)
  protected int my; // mili y (~1000 times y)
  int life;
  int initialLife;
  int overlayIndex; // This refers to the overlay in the overlay pool
  int VelX; // x velocity
  int VelY; // y velocity
  int Gravity; // this is vertical acceleration downwards
  int Transparency;
  int Width;
  int Height;
  int SpriteBegin;
  int rollSprite;
  int SpriteDelta;
  int TransparencyBegin;
  int TransparencyDelta;
  int WidthBegin;
  int WidthDelta;
  int HeightBegin;
  int HeightDelta;
  bool Bounces;
  int GroundY;
  #ifdef SCRIPT_API_v400
  float RotationSpeed;
  float Angle;
  #endif
  /// returns true if particle is alive
  import bool IsAlive();
  /// returns true if particle rect overlaps point
  import bool HitsPoint(int x, int y);
  /// returns true if particle rect overlaps rect
  import bool HitsRect(int x, int y, int width, int height);
  // private stuff
  import void _Init(ParticleDefinition * def, int x, int y, Overlay* ovr); // $AUTOCOMPLETEIGNORE$
  import void _Update(); // $AUTOCOMPLETEIGNORE$
};

struct Emitter {
  /// Set emitter possible particle definitions
  import void SetParticleDefinitions(ParticleDefinition * definitions[], int definitionsCount);
  /// Update emitter position
  import void SetPosition(int x, int y);
  /// Get null terminated array of particles that overlaps with the point
  import Particle * [] ParticlesHitPoint(int x, int y);
  /// Get null terminated array of particles that overlaps with the rect
  import Particle * [] ParticlesHitRect(int x, int y, int width, int height);

  /// Initialize the emitter
  import void Init(int x, int y, ParticleDefinition * defs[], int defCount, int emitCount = 10, int maxParticles = 50);
  /// Emit particles
  import void Emit();
  /// Update all particles
  import void Update();
  
  import protected bool EmitParticleIndex(int i);
  import protected bool EmitSingleParticle();
  protected int X;
  protected int Y;
  protected int emitCount;
  protected int maxParticles;
  protected Particle * particles[]; // Pool of particles
  protected ParticleDefinition * definitions[]; // Array of particle definitions
  protected int definitionsCount; // Count of particle definitions
  protected int lastEmittedParticle;
};

struct ContinuousEmitter extends Emitter {
  protected int emitInterval;
  protected int _emitCooldown;
  protected bool isEmitting;

  /// Continuous Emitter is on and each time a number of loops in emitInterval passes, it will emit particles. 
  import void StartEmitting(int emitInterval = 11);
  /// Continuous Emitter is off and will stop emitting.
  import void StopEmitting();
  import void UpdateContinuous();
};

/// Global Particle Emitter
import ContinuousEmitter GPE;