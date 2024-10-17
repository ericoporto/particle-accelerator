// new module header

managed struct ParticleDefinition {
  int sprite;
  int offsetX; // Offset from the emitter position
  int offsetY; // Offset from the emitter position
  int life;    // Lifetime of the particle
  int vx;      // mili Velocity in x direction
  int vy;      // mili Velocity in y direction
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
  int mx;
  int my;
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

  // Initialize the particle with its position, life, velocity, and transparency
  import void Init(ParticleDefinition* def, int x, int y, int overlayIndex);
  import void Update(); // Update particle position and overlay
  import bool IsAlive(); // Check if particle is still alive
  import bool IsCollidingPoint(int x, int y);
  import bool IsCollidingRect(int x, int y, int width, int height);
};

struct Emitter {
  protected int x;
  protected int y;
  protected int emitParticleCount;
  protected int particleCount;
  protected Particle* particles[]; // Pool of particles
  protected ParticleDefinition* definitions[]; // Array of particle definitions
  protected int definitionsCount; // Count of particle definitions
  protected int lastEmittedParticle;
  
  /// Set emitter possible particle definitions
  import void SetParticleDefinitions(ParticleDefinition* definitions[], int definitionsCount);
  /// Update emitter position
  import void SetPosition(int x, int y);
  /// Get null terminated array of particles that have collision with the point
  import Particle* [] GetParticlesCollidingPoint(int x, int y);
  
  import Particle* [] GetParticlesCollidingRect(int x, int y, int width, int height);

  /// Initialize the emitter
  import void Init(int x, int y, ParticleDefinition* definitions[], int definitionsCount, int emitParticleCount = 10, int particleCount = 50);
  /// Emit a specific particle
  import protected bool EmitParticleIndex(int i);
  /// Emit a single particle
  import protected bool EmitSingleParticle();
  /// Emit particles
  import void Emit();
  /// Update all particles
  import void Update();
};

struct ContinuousEmitter extends Emitter {
  protected int emitRate;
  protected int _emitRateFrame;
  protected bool isEmitting;

  import void StartEmitting(int emitRate = 11);
  import void StopEmitting();
  import void UpdateContinuous();
};

/// Global Particle Emitter
import ContinuousEmitter GPE;