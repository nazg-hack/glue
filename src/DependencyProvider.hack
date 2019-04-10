/**
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * This software consists of voluntary contributions made by many individuals
 * and is licensed under the MIT license.
 *
 * Copyright (c) 2018-2019 Yuuki Takezawa
*/

namespace Nazg\Glue;

final class DependencyProvider<T> extends AbstractDependency<T> implements DependencyInterface {

  public function __construct(
    private ProviderInterface<T> $provider
  ) {}

  <<__Override>>
  public function resolve(
    \Nazg\Glue\Container $container,
    Scope $scope
  ): T {
    if($scope === Scope::SINGLETON) {
      if ($this->instance is nonnull) {
        return $this->shared();
      }
    }
    $this->instance = $this->provider->get($container);
    return $this->instance;
  }
}
