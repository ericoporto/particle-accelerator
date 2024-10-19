// new module header

managed struct ParticleDefinition {
  int sprite;
  int offsetX; // Offset from the emitter position
  int offsetY; // Offset from the emitter position
  int life; // Lifetime of the particle
  int vx; // mili Velocity in x direction
  int vy; // mili Velocity in y direction
  int gravity; // mili Gravity effect on the particle
  int initialSprite;
  int finalSprite;
  int initialTransparency; // Initial transparency
  int finalTransparency; // Final transparency
  int initialWidth; // Initial width
  int finalWidth; // Final width
  int initialHeight; // Initial height
  int finalHeight; // Final height
  bool groundHitBounces;
  int groundY;
  #ifdef SCRIPT_API_v400
  BlendMode BlendMode;
  float rotationSpeed;
  float angle;
  #endif
};

managed struct Particle {
  int sprite;
  int x;
  int y;
  protected int mx; // mili x (~1000 times x)
  protected int my; // mili y (~1000 times y)
  int life;
  int initialLife;
  int overlayIndex; // This refers to the overlay in the overlay pool
  int vx; // x velocity
  int vy; // y velocity
  int gravity; // this is vertical acceleration downwards
  int transparency;
  int width;
  int height;
  int initialSprite;
  int rollSprite;
  int deltaSprite;
  int initialTransparency;
  int deltaTransparency;
  int initialWidth;
  int deltaWidth;
  int initialHeight;
  int deltaHeight;
  bool bounces;
  int groundY;
  #ifdef SCRIPT_API_v400
  float rotationSpeed;
  float angle;
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
  protected int x;
  protected int y;
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